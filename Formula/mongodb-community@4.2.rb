class MongodbCommunityAT42 < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  url "https://fastdl.mongodb.org/osx/mongodb-macos-x86_64-4.2.24.tgz"
  sha256 "15047907fd43362edc721b53a8db56484b6420024fade8d7ada8cb0d4dae767c"

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
