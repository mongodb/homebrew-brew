class MongodbCsfle < Formula
  desc "MongoDB csfle shared library for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  # TODO(MONGOSH-1193): Bump to production version after 6.0 is released
  url "https://downloads.mongodb.com/osx/mongo_csfle_v1-macos-x86_64-enterprise-6.0.0-rc0.tgz"
  sha256 "42ca2389a318b5308cdbc8e688e7784bc2da3f3ea3c2d8a48be4bf9edabacb0b"
  license "MongoDB Customer Agreement"

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
