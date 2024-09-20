class MongodbMongocryptd < Formula
  desc "mongocryptd service for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  if Hardware::CPU.intel?
    url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-x86_64-enterprise-8.0.0.tgz"
    sha256 "3af145ccb1c692f21181648b433a117aafc064c6a86bf9b537f1c7e611c0bb32"
  else
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-arm64-enterprise-8.0.0.tgz"
    sha256 "8739ab01c7b501d1f0694921ba62f9f570665aa1eae806417f96d69ad921eab6"
  end
  license "MongoDB Customer Agreement"

  conflicts_with "mongodb-enterprise"
  conflicts_with "mongodb-enterprise@5.0"
  conflicts_with "mongodb-enterprise@6.0"
  conflicts_with "mongodb-enterprise@7.0"

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
