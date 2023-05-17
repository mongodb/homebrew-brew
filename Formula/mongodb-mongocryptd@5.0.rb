class MongodbMongocryptdAT50 < Formula
  desc "mongocryptd service for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-x86_64-enterprise-5.0.17.tgz"
  sha256 "ce07c62bb2121cb19f07cde5566574a439a8b22d5f847b7eeb3c018fff6f0b73"
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
