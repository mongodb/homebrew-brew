class MongodbCommunityShell < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-shell-macos-x86_64-5.0.11.tgz"
  sha256 "884114d5828d817763cf22962d0c4f921e840ffb0735915c4457d23ae2fb5773"

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
