class MongodbCommunityShell < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"
  url "https://fastdl.mongodb.org/osx/mongodb-shell-osx-ssl-x86_64-4.0.6.tgz"
  sha256 "bcc6c3da65dcdb62b09b044a7f578e0caada5ac1051f6ef41456bc517a542b6a"

  bottle :unneeded

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
