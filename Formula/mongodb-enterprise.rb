class MongodbEnterprise < Formula
  desc "High-performance, schema-free, document-oriented database (Enterprise)"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true
  #
  if Hardware::CPU.intel?
    url "https://downloads.mongodb.com/osx/mongodb-macos-x86_64-enterprise-8.0.1.tgz"
    sha256 "de39899e6c8b6b02b67da3f5b3601565b728087fa699fa1eccb8fe523559cdb1"
  else
    url "https://downloads.mongodb.com/osx/mongodb-macos-arm64-enterprise-8.0.1.tgz"
    sha256 "fa5c95c2af80b7eea6c9efb4b615a44ab792759779341ec5d6e995cf78176fe2"
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

  conflicts_with "mongodb-community"

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
