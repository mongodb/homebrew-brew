class MongodbMongocryptd < Formula
  desc "mongocryptd service for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  if Hardware::CPU.intel?
    url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-x86_64-enterprise-8.2.0.tgz"
    sha256 "f95304bab71a6840393ef537937ad91be0e28ec72ef9ec1c048f1c58656e3916"
  else
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-arm64-enterprise-8.2.0.tgz"
    sha256 "51dac50c7b6248adbaf708d2ee27293aa81b3a2582a806b0e8f1202d1324cad4"
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
