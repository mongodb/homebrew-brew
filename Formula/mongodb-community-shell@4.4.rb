class MongodbCommunityShellAT44 < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-4.4.25.tgz"
  sha256 "9daf8315482e349bf1ddb153e39002688114b942868e6e25afc463bf91781d58"

  keg_only :versioned_formula

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
