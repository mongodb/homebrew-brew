class MongodbCsfle < Formula
  desc "MongoDB csfle shared library for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  license "MongoDB Customer Agreement"

  if Hardware::CPU.arm?
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-arm64-enterprise-6.0.19.tgz"
    sha256 "5c5b5039c4394a4e863b6d506a7b63b2f73ad63df48f6be43c5377c6a4ab4589"
  else
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-x86_64-enterprise-6.0.19.tgz"
    sha256 "489c9e54560659dad3574f75c7c1a47b7fa2fd9ab913677f0fd59c57ac5c38cf"
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
