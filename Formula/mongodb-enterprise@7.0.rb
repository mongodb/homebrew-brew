class MongodbEnterpriseAT70 < Formula
  desc "High-performance, schema-free, document-oriented database (Enterprise)"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true
  #
  if Hardware::CPU.intel?
    url "https://downloads.mongodb.com/osx/mongodb-macos-x86_64-enterprise-7.0.24.tgz"
    sha256 "320a5e548f67f31eeeeb75c463fb300e3093fcc1ba221a65607f9a020b18df82"
  else
    url "https://downloads.mongodb.com/osx/mongodb-macos-arm64-enterprise-7.0.24.tgz"
    sha256 "0bede3f51763522dd778c2f6e98821b5c510450d3902716fe3acaf7d59e047f6"
  end

  license "MongoDB Customer Agreement"

  def caveats
    <<~EOS
      MongoDB Enterprise is licensed under the MongoDB Customer Agreement (https://www.mongodb.com/customer-agreement). Except for evaluation purposes, you may not use MongoDB Enterprise without a commercial license from MongoDB.
    EOS
  end

  option "with-enable-test-commands", "Configures MongoDB to allow test commands such as failpoints"

  depends_on "mongodb-database-tools" => :recommended
  depends_on "mongosh" => :recommended

  conflicts_with "mongodb-enterprise"
  conflicts_with "mongodb-enterprise@5.0"
  conflicts_with "mongodb-enterprise@6.0"
  conflicts_with "mongodb-community"
  conflicts_with "mongodb-community@5.0"
  conflicts_with "mongodb-community@6.0"
  conflicts_with "mongodb-community@7.0"
  conflicts_with "mongodb-mongocryptd@5.0"
  conflicts_with "mongodb-mongocryptd@6.0"
  conflicts_with "mongodb-mongocryptd@7.0"
  conflicts_with "mongodb-mongocryptd"

  def install
    
    inreplace "macos_mongodb.plist" do |s|
      s.gsub!("\#{plist_name}", "#{plist_name}")
      s.gsub!("\#{opt_bin}", "#{opt_bin}")
      s.gsub!("\#{etc}", "#{etc}")
      s.gsub!("\#{HOMEBREW_PREFIX}", "#{HOMEBREW_PREFIX}")
      s.gsub!("\#{var}", "#{var}")
    end

    prefix.install_symlink "macos_mongodb.plist" => "#{plist_name}.plist"
    prefix.install Dir["*"]
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
