class MongodbCommunityShellAT44 < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-4.4.29.tgz"
  sha256 "71adcf61a4b3a0619a1a55abb9b64bface1cab4de00c17e748fd84c04c3504c4"

  keg_only :versioned_formula

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
