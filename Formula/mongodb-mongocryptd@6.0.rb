class MongodbMongocryptdAT60 < Formula
  desc "mongocryptd service for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  if Hardware::CPU.intel?
    url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-x86_64-enterprise-6.0.19.tgz"
    sha256 "3c1c1b46b357bc2212e1fdfb24764dbfcfdc56b838a9ab4f68ce04cd2ae5368f"
  else
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-arm64-enterprise-6.0.19.tgz"
    sha256 "5c5b5039c4394a4e863b6d506a7b63b2f73ad63df48f6be43c5377c6a4ab4589"
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
