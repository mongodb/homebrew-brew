class MongodbEnterpriseAT60 < Formula
  desc "High-performance, schema-free, document-oriented database (Enterprise)"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true
  #
  if Hardware::CPU.intel?
    url "https://downloads.mongodb.com/osx/mongodb-macos-x86_64-enterprise-6.0.26.tgz"
    sha256 "f74cae2d8217cca423355e09f1c88e2af0d723fc649b49659353dcbfc52f454e"
  else
    url "https://downloads.mongodb.com/osx/mongodb-macos-arm64-enterprise-6.0.26.tgz"
    sha256 "8d83c0a891043cb4de074546ed78bf17e45f03501b643397639bad79df0dd4f0"
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
  conflicts_with "mongodb-enterprise@7.0"
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

  service do
    name macos: "#{plist_name}"
  end

  def post_install
    (var/"mongodb").mkpath
    (var/"log/mongodb").mkpath
    if !(File.exist?((etc/"mongod.conf"))) then
      (etc/"mongod.conf").write mongodb_conf
    end
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
