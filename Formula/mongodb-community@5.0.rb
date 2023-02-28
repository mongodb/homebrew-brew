class MongodbCommunityAT50 < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-macos-x86_64-5.0.15.tgz"
  sha256 "e6589b9b5417bb523ed621afcccffd9fca3a8fb983c4c2770994bbcc019c8184"

  option "with-enable-test-commands", "Configures MongoDB to allow test commands such as failpoints"

  depends_on "mongodb-database-tools" => :recommended
  depends_on "mongosh" => :recommended

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
