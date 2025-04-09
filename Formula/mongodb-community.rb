class MongodbCommunity < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  if Hardware::CPU.intel?
    url "https://fastdl.mongodb.org/osx/mongodb-macos-x86_64-8.0.8.tgz"
    sha256 "4fa7335e6f13b626f19e033114c6d80a569bf2a9ae46329c9047248514de1479"
  else
    url "https://fastdl.mongodb.org/osx/mongodb-macos-arm64-8.0.8.tgz"
    sha256 "991c8ad3ef3e0307f01482e69a9c3b1d14815ee124d69f1088d2ed30c7e8bc24"
  end

  option "with-enable-test-commands", "Configures MongoDB to allow test commands such as failpoints"

  depends_on "mongodb-database-tools" => :recommended
  depends_on "mongosh" => :recommended

  conflicts_with "mongodb-enterprise"

  def install
    inreplace "macos_mongodb.plist" do |s|
      s.gsub!("\#{plist_name}", "#{plist_name}")
      s.gsub!("\#{opt_bin}", "#{opt_bin}")
      s.gsub!("\#{etc}", "#{etc}")
      s.gsub!("\#{HOMEBREW_PREFIX}", "#{HOMEBREW_PREFIX}")
      s.gsub!("\#{var}", "#{var}")
    end

    prefix.install Dir["*"]
    prefix.install_symlink "macos_mongodb.plist" => "#{plist_name}.plist"
  end

  def post_install
    (var/"mongodb").mkpath
    (var/"log/mongodb").mkpath
    if !(File.exist?((etc/"mongod.conf"))) then
      (etc/"mongod.conf").write mongodb_conf
    end
  end

  service do
    name macos: "#{plist_name}"
  end

  def mongodb_conf
    cfg = <<~EOS
    systemLog:
      destination: file
      path: #{var}/log/mongodb/mongo.log
      logAppend: true
    storage:
      dbPath: #{var}/mongodb
    net:
      bindIp: 127.0.0.1, ::1
      ipv6: true
    EOS
    if build.with? "enable-test-commands"
      cfg += <<~EOS
      setParameter:
        enableTestCommands: 1
      EOS
    end
    cfg
  end

  test do
    system "#{bin}/mongod", "--sysinfo"
  end
end
