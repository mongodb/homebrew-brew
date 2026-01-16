class MongodbMongocryptdAT80 < Formula
  desc "mongocryptd service for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  if Hardware::CPU.intel?
    url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-x86_64-enterprise-8.0.18.tgz"
    sha256 "8a668553033d6031339309feaee18ef97cd1261791fc42a286b1068494c61e08"
  else
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-arm64-enterprise-8.0.18.tgz"
    sha256 "bf6416a2dfaa1e94da3c1b8b60785ae49d96323c9fb3f468d3390bba845323dd"
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
