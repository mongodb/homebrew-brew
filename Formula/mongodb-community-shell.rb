class MongodbCommunityShell < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-5.0.31.tgz"
  sha256 "6c165f51f2c7de3c86c9704240362273e94de6bbbe138be13c57a7b3659b56e0"

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
