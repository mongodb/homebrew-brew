class MongodbCommunityShell < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-5.0.14.tgz"
  sha256 "fc634f06ca9a5d151d714fc1792b0359051286022d8eca15f26550b19397247b"

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
