require "language/node"

class Mongosh < Formula
  desc "The MongoDB Shell"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.0.5.tgz"
  version "0.0.5"
  sha256 "70aab0f585cb4fc0c1e2c26bbe19d36d2d68022fe2cca85fe8099196a9cd7606"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/mongosh --version"
  end
end
