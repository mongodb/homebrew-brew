require "language/node"

class Mongosh < Formula
  desc "The MongoDB Shell"

  homepage "https://github.com/mongodb-js/mongosh#readme"
  url "https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.8.0.tgz"
  version "0.8.0"

  # This is the checksum of the archive. Can be obtained with:
  # curl -s https://registry.npmjs.org/@mongosh/cli-repl/-/cli-repl-0.8.0.tgz | shasum -a 256
  sha256 "77feadff95f548a09bec4655b5a97d990acf06674b6464ac8794aef53a1fa2fa"

  depends_on "node@14"

  def install
    system "#{Formula["node@14"].bin}/npm", "install", *Language::Node.std_npm_install_args(libexec)
    (bin/"mongosh").write_env_script libexec/"bin/mongosh", :PATH => "#{Formula["node@14"].opt_bin}:$PATH"
  end

  test do
    system "#{bin}/mongosh --version"
  end
end
