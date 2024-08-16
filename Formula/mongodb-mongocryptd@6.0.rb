class MongodbMongocryptdAT60 < Formula
  desc "mongocryptd service for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  if Hardware::CPU.intel?
    url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-x86_64-enterprise-6.0.17.tgz"
    sha256 "0ec562646af3edd6c749ba9e72a9ccf4258fa17cf8349c45afc8d4a95cc7a366"
  else
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-arm64-enterprise-6.0.17.tgz"
    sha256 "efb1c72ebb83b36e448cb972625ec31c5e9508f9287d0b08f924f80d0b8e922c"
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
