class MongodbDatabaseTools < Formula
  desc "This package contains standard utilities for interacting with MongoDB."
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  if Hardware::CPU.intel?
    url "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-x86_64-100.16.0.zip"
    sha256 "a5ce349b1e5c5c924358809759b829b5961a1d77b7bc72a35c7e2b680ed79169"
  else
    url "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-arm64-100.16.0.zip"
    sha256 "9e867da825d1c91c1f6514cf02c40f51f047c5e5d92c6a14a5528c765702166b"
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
