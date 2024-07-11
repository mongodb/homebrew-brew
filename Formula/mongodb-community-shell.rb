class MongodbCommunityShell < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-5.0.28.tgz"
  sha256 "d630d3a5d3b58fe85cd92e39b719a01120c3c3447b0e1b57a5e440e6127b9c26"

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
