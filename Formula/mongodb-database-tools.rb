class MongodbDatabaseTools < Formula
  desc "This package contains standard utilities for interacting with MongoDB."
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  if Hardware::CPU.intel?
    url "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-x86_64-100.12.2.zip"
    sha256 "b7546c4fb22de2786c44d9fec6a4d52df7dcaf6bdf236beb7ed9172f068e50e1"
  else
    url "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-arm64-100.12.2.zip"
    sha256 "40189a68db848bd152e040b4f19af59ff1787ab7850773d5a080c403d6edf9e7"
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
