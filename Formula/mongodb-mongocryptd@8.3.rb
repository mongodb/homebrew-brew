class MongodbMongocryptdAT83 < Formula
  desc "mongocryptd service for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  if Hardware::CPU.intel?
    url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-x86_64-enterprise-8.3.13.tgz"
    sha256 "e9dfeb07755c7cab8e22b477f371a9e0ba8d14297c5eb4ad56d26e125422e46b"
  else
    url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-arm64-enterprise-8.3.13.tgz"
    sha256 "4d5c2a4376c6963c4f5f9af27fe5f59abd6f1e7c098ae528ef6527f4485084a4"
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
