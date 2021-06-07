class MongodbMongocryptd < Formula
  desc "mongocryptd service for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-x86_64-enterprise-4.4.6.tgz"
  sha256 "bdf8aa2110b1f72c847b6b49f73fb855ae58549a2640ea69d7971740d7ff10db"
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
