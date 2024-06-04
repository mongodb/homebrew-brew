class MongodbCommunityShell < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-5.0.27.tgz"
  sha256 "bc710e674e413e733e74acde92e63f56f4f8074f12091bb5d59f9f9ee92c15dc"

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
