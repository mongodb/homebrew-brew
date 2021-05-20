require "language/node"

class Mongosh < Formula
  desc "The MongoDB Shell"

  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.13.2.tgz"
  version "0.13.2"

  # This is the checksum of the archive. Can be obtained with:
  # curl -s https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.13.2.tgz | shasum -a 256
  sha256 "51bbbdc2e974da4708c95ed8a88cf8cea9f4c7aa2143a4af57d67b3e036d69c9"

  depends_on "node@14"

  def install
    system "#{Formula["node@14"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", :PATH => "#{Formula["node@14"].opt_bin}:$PATH"
  end

  test do
    system "#{bin}/mongosh --version"
  end
end
