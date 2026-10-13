class MongodbMongocryptd < Formula
  desc "mongocryptd service for Client Side Encryption"
  homepage "https://www.mongodb.com/"

  if Hardware::CPU.intel?
    url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-x86_64-enterprise-9.0.4.tgz"
    sha256 "4b5526821758c66e5dad44c6ab2f2617e14b0392618fab117c76a469287f7382"
  else
    url "https://downloads.mongodb.com/osx/mongodb-cryptd-macos-arm64-enterprise-9.0.4.tgz"
    sha256 "adec2dadc6ce3d8b64c7715f9644b8fa385d05b4bab6787c522739bbe292317c"
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
