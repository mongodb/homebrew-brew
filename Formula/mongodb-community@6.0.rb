class MongodbCommunityAT60 < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  if Hardware::CPU.intel?
    url "https://fastdl.mongodb.org/osx/mongodb-macos-x86_64-6.0.18.tgz"
    sha256 "1cd23f3c5445f00f409622476368e3e88d13e04535efd770582b8d4a7243d32d"
  else
    url "https://fastdl.mongodb.org/osx/mongodb-macos-arm64-6.0.18.tgz"
    sha256 "4d9d0bdb3efd7e32721d85bc5c3b4f829f80a6b5b18db727478a9b6a21209621"
  end

  option "with-enable-test-commands", "Configures MongoDB to allow test commands such as failpoints"

  depends_on "mongodb-database-tools" => :recommended
  depends_on "mongosh" => :recommended

  conflicts_with "mongodb-enterprise"
  conflicts_with "mongodb-enterprise@5.0"
  conflicts_with "mongodb-enterprise@6.0"
  conflicts_with "mongodb-enterprise@7.0"
  conflicts_with "mongodb-community"
  conflicts_with "mongodb-community@5.0"
  conflicts_with "mongodb-community@7.0"

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
