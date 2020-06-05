require "language/node"

class Mongosh < Formula
  desc "The MongoDB Shell"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.0.5.tgz"
  version "0.0.5"

  # This is the checksum of the archive. Can be obtained with:
  # curl -s https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.0.5.tgz | shasum -a 256
  sha256 "aa3d6426943b999a5b6002cb11ddae48b355ee73040bd2a7bb4da25729362b66"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/mongosh --version"
  end
end
