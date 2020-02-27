class MongodbDatabaseTools < Formula
  desc "This package contains standard utilities for interacting with MongoDB."
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "http://downloads.mongodb.org/tools/db/mongodb-database-tools-macos-x86_64-100.0.0-alpha1.tgz"
  sha256 "20f7b778255570473d9e9edd2e0b970ac0151aa25e93e0f51367415b8d6c1584"

  bottle :unneeded

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
