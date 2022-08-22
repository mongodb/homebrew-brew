class MongodbCommunityShellAT42 < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-4.2.22.tgz"
  sha256 "14d958063cc39b0e0f7fd64c4960b4fb0443519ee56407fe15b5c01f6fb5e2d3"

  keg_only :versioned_formula

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
