class MongodbCommunityShell < Formula
  desc "An interactive JavaScript command-line interface to MongoDB"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  require 'net/http'
  require 'json'
  current = JSON.parse(Net::HTTP.get(URI('http://downloads.mongodb.org/current.json')))
  latest_ga = current['versions'].select { |r|
    r['production_release'] == true
  } .max_by { |v|
    Gem::Version.new(v['version'])
  }
  latest_ga_ver = latest_ga['version']
  dl_prefix = 'https://fastdl.mongodb.org/osx/mongodb-shell'
  dl_platform = if Gem::Version.new(latest_ga_ver) < Gem::Version.new('4.2.0')
                  'osx-ssl-x86_64'
                else
                  'macos-x86_64'
                end
  dl_url = "#{dl_prefix}-#{dl_platform}-#{latest_ga_ver}.tgz"
  dl_sha256 = Net::HTTP.get(URI("#{dl_url}.sha256"))
                       .strip.split(' ')[0]

  url dl_url
  sha256 dl_sha256

  bottle :unneeded

  def install
    prefix.install Dir["*"]
  end

  test do
    system "#{bin}/mongo", "--version"
  end
end
