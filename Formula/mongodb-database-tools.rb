class MongodbDatabaseTools < Formula
  desc "This package contains standard utilities for interacting with MongoDB."
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  if Hardware::CPU.intel?
    url "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-x86_64-100.15.0.zip"
    sha256 "c20626777ebd5c4dbd24bfbd637c58de6664f100272520b937e5d0861fa6ea1c"
  else
    url "https://fastdl.mongodb.org/tools/db/mongodb-database-tools-macos-arm64-100.15.0.zip"
    sha256 "82fe367c2e080c384cf67ff81cfd5c0ddb4d877cc6553e6539f3fa28b9ce5c3e"
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
