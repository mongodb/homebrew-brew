class MongodbCommunityShellAT42 < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-4.2.23.tgz"
  sha256 "1c033ab0d374182f93fa6874e41aa413cd8d657391f1e39d853e7a198144aa22"

  keg_only :versioned_formula

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
