class MongodbCsfle < Formula
  desc "MongoDB csfle shared library for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  license "MongoDB Customer Agreement"

  if Hardware::CPU.arm?
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-arm64-enterprise-6.0.17.tgz"
    sha256 "efb1c72ebb83b36e448cb972625ec31c5e9508f9287d0b08f924f80d0b8e922c"
  else
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-x86_64-enterprise-6.0.17.tgz"
    sha256 "2ad5edae70c0e876844e356f2f2b2eec4cd376e1e8071b63b584bff5e6108cef"
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
