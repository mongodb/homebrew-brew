class MongodbCommunityShellAT44 < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-4.4.21.tgz"
  sha256 "bc51d524e7496cf87a1f3418c650f835988ed5b09dab8f2b3fcc84f2a9086508"

  keg_only :versioned_formula

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
