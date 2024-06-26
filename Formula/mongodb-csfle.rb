class MongodbCsfle < Formula
  desc "MongoDB csfle shared library for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  license "MongoDB Customer Agreement"

  if Hardware::CPU.arm?
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-arm64-enterprise-6.0.16.tgz"
    sha256 "01cac140814f0a871f2df7dbb6898acb6fa96b1113773940ef560740c236efdb"
  else
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-x86_64-enterprise-6.0.16.tgz"
    sha256 "459c29bc9683ed1433d0d66d2c7232bf34765284980bc3c6165c95e844ecf2b9"
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
