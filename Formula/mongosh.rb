require "language/node"

class Mongosh < Formula
  desc "The MongoDB Shell"
  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.0.7.tgz"
  version "0.0.7"

  # This is the checksum of the archive. Can be obtained with:
  # curl -s https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.0.7.tgz | shasum -a 256
  sha256 "c4ce102fcaead688327516b6310562860db25d0c067ac5e20cd96f244002ab82"

  depends_on "node@12"

  def install
    system "#{Formula["node@12"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", :PATH => "#{Formula["node@12"].opt_bin}:$PATH"
  end

  test do
    system "#{bin}/mongosh --version"
  end
end
