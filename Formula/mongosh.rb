require "language/node"

class Mongosh < Formula
  desc "The MongoDB Shell"

  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.11.0.tgz"
  version "0.11.0"

  # This is the checksum of the archive. Can be obtained with:
  # curl -s https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.11.0.tgz | shasum -a 256
  sha256 "b31417eb6f216e3be180f5e4200126470e2e682a0ef7aec6a13ceed8c6cec757"

  depends_on "node@14"

  def install
    system "#{Formula["node@14"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", :PATH => "#{Formula["node@14"].opt_bin}:$PATH"
  end

  test do
    system "#{bin}/mongosh --version"
  end
end
