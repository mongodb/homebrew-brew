class MongodbCommunity < Formula
  desc "High-performance, schema-free, document-oriented database"
  homepage "https://www.mongodb.com/"

  # frozen_string_literal: true

  if Hardware::CPU.intel?
    url "https://fastdl.mongodb.org/osx/mongodb-macos-x86_64-6.0.5.tgz"
    sha256 "2f470d90978771d799cd0097f0d9da5e18e27af35ee507be759f54cfc5e69217"
  else
    url "https://fastdl.mongodb.org/osx/mongodb-macos-arm64-6.0.5.tgz"
    sha256 "330abd73261487ab37d04b32cfcf3c8e550c3c92682361089d3cec8138019b4e"
  end

  option "with-enable-test-commands", "Configures MongoDB to allow test commands such as failpoints"

  depends_on "mongodb-database-tools" => :recommended
  depends_on "mongosh" => :recommended

  conflicts_with "mongodb-enterprise"

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
