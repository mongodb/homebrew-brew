class MongodbMongocryptd < Formula
  desc "mongocryptd service for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  if Hardware::CPU.intel?
    url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-x86_64-enterprise-8.2.4.tgz"
    sha256 "20b8448053a46416856e0133bad13b22c79d8b91a78af6c115f67a8962b7cb7b"
  else
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-arm64-enterprise-8.2.4.tgz"
    sha256 "f755ec683adc3efd826da816ab6b65d2a1d0231df14547c3e9492acd8786c052"
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
