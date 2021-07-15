# typed: false
# frozen_string_literal: true

# This file was generated by GoReleaser. DO NOT EDIT.
class Mongocli < Formula
  desc "The MongoDB Command Line Interface (mongocli) is a tool for managing your MongoDB cloud services, like MongoDB Atlas, MongoDB Cloud Manager, and MongoDB Ops Manager."
  homepage "https://github.com/mongodb/mongocli"
  version "1.19.0"
  license "Apache-2.0"
  bottle :unneeded

  if OS.mac? && Hardware::CPU.intel?
    url "https://github.com/mongodb/mongocli/releases/download/v1.19.0/mongocli_1.19.0_macos_x86_64.zip"
    sha256 "cf77508e703e799ed2987e136a9a829780f654d5587e433a708be9f2181e676d"
  end
  if OS.linux? && Hardware::CPU.intel?
    url "https://github.com/mongodb/mongocli/releases/download/v1.19.0/mongocli_1.19.0_linux_x86_64.tar.gz"
    sha256 "0359b6b1d1bce6a54769d34ffea2cb3fa8253112054c9c1e228fb62e13632922"
  end

  def install
    bin.install "mongocli"
    (bash_completion/"mongocli.sh").write `#{bin}/mongocli completion bash`
    (zsh_completion/"_mongocli").write `#{bin}/mongocli completion zsh`
    (fish_completion/"mongocli.fish").write `#{bin}/mongocli completion fish`
  end

  test do
    system "#{bin}/mongocli --version"
  end
end
