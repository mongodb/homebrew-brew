class MongodbDatabaseTools < Formula
  desc "This package contains standard utilities for interacting with MongoDB."
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  sha256 "0bd3a30d5eb2ffc3a77cd3b8fef39c477b5ec168cc62c3dec8fb43863586b3b1"

  if Hardware::CPU.intel?
    url "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-x86_64-100.7.1.zip"
    sha256 "43479d39caaa9df8e88c0794fd71c3a31d3a2b33f5c819281af5046cbf5686b3"
  else
    url "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-arm64-100.7.1.zip"
    sha256 "2f69f8115d1bed8bbc57cfe0435c5deb14ef93f2b490277be5545bece426d8f1"
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
