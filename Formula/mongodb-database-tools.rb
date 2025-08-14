class MongodbDatabaseTools < Formula
  desc "This package contains standard utilities for interacting with MongoDB."
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  if Hardware::CPU.intel?
    url "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-x86_64-100.13.0.zip"
    sha256 "6f01bd800463162cbd4f6ce26affad82c1035f6055c62f0765bf66bf7a28507b"
  else
    url "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-arm64-100.13.0.zip"
    sha256 "2924ba82a80115964dc0284a6273086edef3945b77bf61ad9477d47380804b2d"
  end
  
  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/bsondump", "--version"
    system "#{bin}/mongoimport", "--version"
    system "#{bin}/mongoexport", "--version"
    system "#{bin}/mongodump", "--version"
    system "#{bin}/mongorestore", "--version"
    system "#{bin}/mongostat", "--version"
    system "#{bin}/mongofiles", "--version"
    system "#{bin}/mongotop", "--version"
  end
end
