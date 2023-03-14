class MongodbEnterpriseAT44 < Formula
  desc "High-performance, schema-free, document-oriented database (Enterprise)"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://downloads.mongodb.com/osx/mongodb-macos-x86_64-enterprise-4.4.19.tgz"
  sha256 "0f373febe5761b713b20f8602fc341a07c39c1e3526e44452130cb0ee81ecbdc"
  license "MongoDB Customer Agreement"

  def caveats
    <<~EOS
      MongoDB Enterprise is licensed under the MongoDB Customer Agreement (https://www.mongodb.com/customer-agreement). Except for evaluation purposes, you may not use MongoDB Enterprise without a commercial license from MongoDB.
    EOS
  end

  depends_on "mongodb-database-tools" => :recommended

  option "with-enable-test-commands", "Configures MongoDB to allow test commands such as failpoints"

  keg_only :versioned_formula

  def install
    prefix.install Dir["*"]
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

  service do
    run [opt_bin/"mongod", "--config", etc/"mongod.conf"]
    working_dir HOMEBREW_PREFIX
    log_path var/"log/mongodb/output.log"
    error_log_path var/"log/mongodb/output.log"
  end

  test do
    system "#{bin}/mongod", "--sysinfo"
  end
end
