#!/usr/bin/env python3
"""Validate formula consistency in the mongodb/homebrew-brew tap.

Runs as a GitHub Actions check on every PR that touches Formula/ or Aliases/.
Catches the most dangerous automation failures:

  * Pinned @<series>.rb file with a class name that doesn't match the filename
    (e.g. class MongodbCommunity instead of MongodbCommunityAT83).
  * Unpinned formula bumped to a new series but no @<old_series>.rb was
    created to preserve the previous pin.
  * A @<series>.rb pins a version from the wrong series.
  * Pinned @<series>.rb file pins different checksums/versions than what the
    unpinned formula had on the base branch before the bump.
  * Aliases missing or pointing at the wrong formula after a series transition.
  * SHA256 values that are not 64-char hex strings.
  * x86_64 and arm64 in the same formula pinning different series (or, for
    community/enterprise which ship in lockstep, different patch versions).
  * A pinned formula somehow pinning a newer version than the unpinned one.

Usage:
    python scripts/validate_formulae.py [--base-branch master]

Exits non-zero if any errors are found.
"""

import argparse
import os
import re
import subprocess
import sys
from pathlib import Path

# Products that have both an unversioned formula and pinned @<series> variants.
# Products like mongodb-csfle and mongodb-database-tools are versionless-only
# and are excluded from alias/series checks.
VERSIONED_PRODUCTS = [
    "mongodb-community",
    "mongodb-enterprise",
    "mongodb-mongocryptd",
]

# Products whose macOS archives pin the exact same version for x86_64 and
# arm64. mongocryptd builds from crypt_shared artifacts whose per-arch builds
# ship on independent cadences, so patch-level divergence within a series is
# normal there (e.g. x86_64=8.0.28 vs arm64=8.0.26); only arches landing on
# different series is an error for it.
LOCKSTEP_PRODUCTS = {"mongodb-community", "mongodb-enterprise"}

FORMULA_DIR = Path("Formula")
ALIASES_DIR = Path("Aliases")
DEFAULT_BASE_BRANCH = "master"

URL_SHA_RE = re.compile(
    r'url "(?P<url>[^"]+)"\n[ \t]*sha256 "(?P<sha256>[0-9a-fA-F]{64})"'
)
VERSION_RE = re.compile(r"(\d+\.\d+\.\d+)")
CLASS_RE = re.compile(r"^class\s+(\w+)\s*<\s*Formula", re.MULTILINE)

errors: list[str] = []
warnings: list[str] = []


def error(msg: str) -> None:
    errors.append(msg)
    print(f"ERROR: {msg}")


def warning(msg: str) -> None:
    warnings.append(msg)
    print(f"WARN: {msg}")


# ---------------------------------------------------------------------------
# Parsing helpers
# ---------------------------------------------------------------------------

def parse_formula(path: Path) -> list[tuple[str, str]]:
    """Return a list of (url, sha256) pairs from a formula file."""
    text = path.read_text()
    return [(m["url"], m["sha256"]) for m in URL_SHA_RE.finditer(text)]


def extract_version(url: str) -> str | None:
    """Extract the X.Y.Z version string from a MongoDB download URL."""
    m = VERSION_RE.search(url)
    return m.group(1) if m else None


def version_tuple(v: str) -> tuple[int, ...]:
    return tuple(int(x) for x in v.split("."))


def series(v: str) -> str:
    return ".".join(v.split(".")[:2])


def expected_class_name(filename: str) -> str:
    """Compute the Homebrew class name for a formula filename.

    Mirrors Homebrew's Formulary.class_s:
      1. Capitalize the string.
      2. Replace [-_.\\s]([a-zA-Z0-9]) with the uppercased capture.
      3. Replace '+' with 'x'.
      4. Replace first (.)@(\\d) with \\1AT\\2.

    e.g. "mongodb-community@8.3" -> "MongodbCommunityAT83"
         "mongodb-community"      -> "MongodbCommunity"
    """
    stem = filename.removesuffix(".rb")
    class_name = stem.capitalize()
    class_name = re.sub(r"[-_.\s]([a-zA-Z0-9])", lambda m: m.group(1).upper(), class_name)
    class_name = class_name.replace("+", "x")
    class_name = re.sub(r"(.)@(\d)", r"\1AT\2", class_name, count=1)
    return class_name


# ---------------------------------------------------------------------------
# Repo introspection
# ---------------------------------------------------------------------------

def get_formula_files() -> dict[str, dict]:
    """Return {product: {"unpinned": Path|None, "pinned": {series: Path}}}."""
    result: dict[str, dict] = {}
    if not FORMULA_DIR.exists():
        return result

    for product in VERSIONED_PRODUCTS:
        result[product] = {"unpinned": None, "pinned": {}}

        unpinned = FORMULA_DIR / f"{product}.rb"
        if unpinned.exists():
            result[product]["unpinned"] = unpinned

        for entry in sorted(FORMULA_DIR.iterdir()):
            name = entry.name
            if name.startswith(f"{product}@") and name.endswith(".rb"):
                s = name[len(product) + 1 : -3]
                result[product]["pinned"][s] = entry

    return result


def get_aliases() -> dict[str, Path]:
    """Return {alias_name: resolved_path} for every entry in Aliases/."""
    aliases: dict[str, Path] = {}
    if not ALIASES_DIR.exists():
        return aliases

    for entry in sorted(ALIASES_DIR.iterdir()):
        if entry.is_symlink():
            target = os.readlink(entry)
            aliases[entry.name] = (ALIASES_DIR / target).resolve()
        elif entry.is_file():
            content = entry.read_text().strip()
            if content:
                aliases[entry.name] = (ALIASES_DIR / content).resolve()

    return aliases


def get_base_branch_formula(product: str, base_branch: str) -> list[tuple[str, str]]:
    """Return (url, sha256) pairs from Formula/<product>.rb on the base branch."""
    for ref in (f"origin/{base_branch}", base_branch):
        try:
            result = subprocess.run(
                ["git", "show", f"{ref}:Formula/{product}.rb"],
                capture_output=True,
                text=True,
            )
            if result.returncode == 0:
                return [(m["url"], m["sha256"]) for m in URL_SHA_RE.finditer(result.stdout)]
        except Exception:
            pass
    return []


# ---------------------------------------------------------------------------
# Checks
# ---------------------------------------------------------------------------

def check_class_name(path: Path, label: str) -> None:
    """Verify the Ruby class name matches the Homebrew convention for the filename."""
    text = path.read_text()
    m = CLASS_RE.search(text)
    if not m:
        error(f"{label}: no `class ... < Formula` declaration found")
        return
    actual = m.group(1)
    expected = expected_class_name(path.name)
    if actual != expected:
        error(
            f"{label}: class name `{actual}` does not match expected `{expected}` "
            f"for filename {path.name}"
        )


def check_formula_consistency(
    path: Path, label: str, exact_arch_lockstep: bool
) -> set[str] | None:
    """Verify sha256 validity and per-arch version consistency.

    Returns the set of versions pinned across arches, or None on failure.
    For lockstep products (community/enterprise) any per-arch version
    difference is an error; otherwise only arches pinned to different series
    are an error -- patch-level divergence within a series is expected for
    crypt_shared-based products (mongocryptd).
    """
    pairs = parse_formula(path)
    if not pairs:
        error(f"{label}: no url/sha256 pairs found")
        return None

    versions: set[str] = set()
    for url, sha in pairs:
        v = extract_version(url)
        if v is None:
            error(f"{label}: could not extract version from {url}")
            continue
        versions.add(v)

    if len(versions) > 1:
        if exact_arch_lockstep:
            error(f"{label}: arches pin different versions: {sorted(versions)}")
        elif len({series(v) for v in versions}) > 1:
            error(f"{label}: arches pin different series: {sorted(versions)}")

    return versions or None


def validate(base_branch: str) -> None:
    formulae = get_formula_files()
    aliases = get_aliases()

    for product in VERSIONED_PRODUCTS:
        info = formulae.get(product, {"unpinned": None, "pinned": {}})
        lockstep = product in LOCKSTEP_PRODUCTS

        if info["unpinned"] is None and not info["pinned"]:
            warning(f"{product}: no formula files found, skipping")
            continue

        if info["unpinned"] is None:
            error(f"{product}: missing unpinned formula Formula/{product}.rb")
            continue

        check_class_name(info["unpinned"], product)

        unpinned_versions = check_formula_consistency(
            info["unpinned"], product, lockstep
        )
        if unpinned_versions is None:
            continue

        # With cross-series arch divergence already an error, the series is
        # unambiguous; compare pinned formulae against the newest arch.
        unpinned_v = max(unpinned_versions, key=version_tuple)
        unpinned_series = series(unpinned_v)

        if unpinned_series in info["pinned"]:
            warning(
                f"{product}: Formula/{product}@{unpinned_series}.rb exists "
                f"while unpinned formula also pins series {unpinned_series} "
                f"(unpinned={unpinned_v}). This is valid as an interim state "
                f"but should be resolved when the unversioned formula moves "
                f"to a new series."
            )

        pinned_versions: dict[str, set[str]] = {}
        for s, path in sorted(info["pinned"].items()):
            label = f"{product}@{s}"
            check_class_name(path, label)
            pvs = check_formula_consistency(path, label, lockstep)
            if pvs is None:
                continue
            pinned_versions[s] = pvs
            wrong = sorted(v for v in pvs if series(v) != s)
            if wrong:
                error(
                    f"{label}: pins version(s) {wrong} "
                    f"(series {sorted({series(v) for v in wrong})}), "
                    f"expected series {s}"
                )

        for s, pvs in pinned_versions.items():
            newest = max(pvs, key=version_tuple)
            if version_tuple(newest) > version_tuple(unpinned_v):
                error(
                    f"{product}: unpinned formula pins {unpinned_v} "
                    f"but @{s} pins {newest} (newer)"
                )

        # In this tap, only the unversioned release has an alias. The alias
        # name uses the current series (e.g. mongodb-community@8.3 -> unversioned).
        expected_unpinned = (FORMULA_DIR / f"{product}.rb").resolve()
        unpinned_alias = f"{product}@{unpinned_series}"
        if unpinned_alias not in aliases:
            error(f"{product}: missing alias Aliases/{unpinned_alias}")
        elif aliases[unpinned_alias] != expected_unpinned:
            error(
                f"{product}: alias {unpinned_alias} -> {aliases[unpinned_alias]}, "
                f"expected {expected_unpinned}"
            )

        # When the unversioned formula moved to a new series, verify that a
        # pinned @<old_series>.rb was created and that it preserves the exact
        # URLs and checksums the unversioned formula had on the base branch.
        base_pairs = get_base_branch_formula(product, base_branch)
        if base_pairs:
            base_v = None
            for url, _ in base_pairs:
                base_v = extract_version(url)
                if base_v:
                    break

            if base_v and series(base_v) != unpinned_series:
                old_series = series(base_v)
                if old_series not in info["pinned"]:
                    error(
                        f"{product}: unpinned formula moved from series {old_series} "
                        f"to {unpinned_series}, but no Formula/{product}@{old_series}.rb "
                        f"was created to preserve the old pin"
                    )
                else:
                    pinned_path = info["pinned"][old_series]
                    pinned_pairs = parse_formula(pinned_path)
                    if pinned_pairs != base_pairs:
                        error(
                            f"{product}@{old_series}: URLs/checksums do not match "
                            f"what the unversioned formula had on {base_branch}. "
                            f"Expected {base_pairs}, got {pinned_pairs}"
                        )

    for alias_name, target in sorted(aliases.items()):
        base = alias_name.split("@")[0]
        if base not in VERSIONED_PRODUCTS:
            continue
        if not target.exists():
            error(f"alias {alias_name} -> {target} but target does not exist")

    if errors:
        print(f"\n{len(errors)} error(s), {len(warnings)} warning(s)")
        sys.exit(1)
    elif warnings:
        print(f"\n{len(warnings)} warning(s)")
    else:
        print("All checks passed.")


if __name__ == "__main__":
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument(
        "--base-branch",
        default=DEFAULT_BASE_BRANCH,
        help=f"Base branch to compare against (default: {DEFAULT_BASE_BRANCH})",
    )
    args = parser.parse_args()
    validate(args.base_branch)
