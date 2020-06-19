require "language/node"

class Mongosh < Formula
  desc "The MongoDB Shell"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.0.6.tgz"
  version "0.0.6"

  # This is the checksum of the archive. Can be obtained with:
  # curl -s https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.0.6.tgz | shasum -a 256
  sha256 "23bb944fc189778f72c7276806abe69a61e711b938d53645cfe8dd2668178313"

  depends_on "node@12"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/mongosh --version"
  end
end
