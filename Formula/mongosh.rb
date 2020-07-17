require "language/node"

class Mongosh < Formula
  desc "The MongoDB Shell"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.0.8.tgz"
  version "0.0.8"

  # This is the checksum of the archive. Can be obtained with:
  # curl -s https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.0.8.tgz | shasum -a 256
  sha256 "a555a3a39e693b5e4f92d0435775b6d450fa7b75b19d2fac77176ba9cac80224"

  depends_on "node@12"

  def install
    system "#{Formula["node@12"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", :PATH => "#{Formula["node@12"].opt_bin}:$PATH"
  end

  test do
    system "#{bin}/mongosh --version"
  end
end
