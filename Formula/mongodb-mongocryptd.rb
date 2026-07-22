class MongodbMongocryptd < Formula
  desc "mongocryptd service for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  if Hardware::CPU.intel?
    url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-x86_64-enterprise-8.3.7.tgz"
    sha256 "98294749fd235f318751fb3d9dc76b69b3bf57bf66b93a07f76e560b4e75f485"
  else
    url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-arm64-enterprise-8.3.7.tgz"
    sha256 "1a99fa8c41ddb5fbe61bae41f81ff46d32c9c5c0e86a9a54a3b8841d012b1f38"
  end
  license "MongoDB Customer Agreement"

  def caveats
    <<~EOS
      mongocryptd is licensed under the MongoDB Customer Agreement (https://www.mongodb.com/customer-agreement). Except for evaluation purposes, you may not use mongocryptd without a commercial license from MongoDB.
    EOS
  end

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongocryptd", "--version"
  end
end
