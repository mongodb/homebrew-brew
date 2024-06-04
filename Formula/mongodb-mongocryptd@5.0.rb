class MongodbMongocryptdAT50 < Formula
  desc "mongocryptd service for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-x86_64-enterprise-5.0.27.tgz"
  sha256 "4e01d797d7f2658dc1618d003c928e6e631748fc7365e25fe61d68e63f455fe3"
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
