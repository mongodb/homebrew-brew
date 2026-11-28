class MongodbDatabaseTools < Formula
  desc "This package contains standard utilities for interacting with MongoDB."
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  if Hardware::CPU.intel?
    url "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-x86_64-100.20.1.zip"
    sha256 "de677258cb2dd2f8dfce714021dcf5ebdd812b07f391118d3af5200370d2f67c"
  else
    url "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-arm64-100.20.1.zip"
    sha256 "2d49b4bd58477ce7ffbad2c4d1a686f2befa3ce27e8c7cf8fcd2869d8f73063a"
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
