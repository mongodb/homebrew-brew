class MongodbMongocryptdAT42 < Formula
  desc "mongocryptd service for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-x86_64-enterprise-4.2.24.tgz"
  sha256 "30886f4670f65b7064aca46ee1d43be10ee1983161c639e0aaae68cbc6d38d14"
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
