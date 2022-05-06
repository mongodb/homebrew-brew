class MongodbCsfle < Formula
  desc "MongoDB csfle shared library for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  sha256_aarch64 = "5e5bc88bcadf256c7dcea08a7aa55a552630de6e6919fcf3215b5e8171231c03"
  sha256_x86_64 = "4f1043d8b07ace6032a52eb41b193b3380061a7564ce21ffae24b1ccc0e5c558"
  license "MongoDB Customer Agreement"

  if Hardware::CPU.arm?
    # TODO(MONGOSH-1193): Bump to production version after 6.0 is released
    url "https://downloads.mongodb.com/osx/mongo_csfle_v1-macos-arm64-enterprise-6.0.0-rc4.tgz"
    sha256 sha256_aarch64
  else
    # TODO(MONGOSH-1193): Bump to production version after 6.0 is released
    url "https://downloads.mongodb.com/osx/mongo_csfle_v1-macos-x86_64-enterprise-6.0.0-rc4.tgz"
    sha256 sha256_x86_64
  end


  def caveats
    <<~EOS
      The MongoDB csfle shared library is licensed under the MongoDB Customer Agreement (https://www.mongodb.com/customer-agreement). Except for evaluation purposes, you may not use mongocryptd without a commercial license from MongoDB.
    EOS
  end

  def install
    prefix.install Dir["*"]
  end

  test do
    system "otool", "-L", "#{lib}/mongo_csfle_v1.dylib"
  end
end
