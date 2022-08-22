class MongodbCsfle < Formula
  desc "MongoDB csfle shared library for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  license "MongoDB Customer Agreement"

  if Hardware::CPU.arm?
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-arm64-enterprise-6.0.1.tgz"
    sha256 "5235a769eba0f2206a1442f3e9850805672b89da85cfcc885d35853d5cdf3103"
  else
    url "https://downloads.mongodb.com/osx/mongo_crypt_shared_v1-macos-x86_64-enterprise-6.0.1.tgz"
    sha256 "6f8340cba8f4df756b9327f2bcded1ab529c16da3b4f622fc3bcdf9f6cd1795f"
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
