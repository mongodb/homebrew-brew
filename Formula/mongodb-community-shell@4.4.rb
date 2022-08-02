class MongodbCommunityShellAT44 < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-4.4.15.tgz"
  sha256 "5ad67c5814a04d6be146f1769ed062c3d5635ad8d21b433ec252ddbaac4e9c64"

  keg_only :versioned_formula

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
