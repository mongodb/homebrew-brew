class MongodbCommunityShellAT44 < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-4.4.16.tgz"
  sha256 "0d06ab9c665f4069f91d743dc1474945775638721009c087fabbd7757eda9023"

  keg_only :versioned_formula

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
