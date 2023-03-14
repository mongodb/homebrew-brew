class MongodbCommunityShellAT42 < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-4.2.24.tgz"
  sha256 "3b67d8a41ec1cd6cb17ad1491821f983bcbe8c9f15aea77192cc11ae662a64d9"

  keg_only :versioned_formula

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
