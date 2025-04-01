class Libmongocrypt < Formula
  desc "C library for Client Side Encryption"
  homepage "https://github.com/mongodb/libmongocrypt"
  url "https://github.com/mongodb/libmongocrypt/archive/1.13.1.tar.gz"
  sha256 "7d7cbac0faa29dce2da9c1da10015a38324021b59d46a9815f08211941ed36c4"
  license "Apache-2.0"
  head "https://github.com/mongodb/libmongocrypt.git"

  depends_on "cmake" => :build
  depends_on "mongo-c-driver" => :build

  def install
    cmake_args = std_cmake_args
    cmake_args << if build.head?
      "-DBUILD_VERSION=1.14.0-pre"
    else
      "-DBUILD_VERSION=1.13.1"
    end
    # Homebrew includes FETCHCONTENT_FULLY_DISCONNECTED=ON as part of https://github.com/Homebrew/brew/pull/17075
    # Set back the previous default to prevent build failure.
    cmake_args << "-DFETCHCONTENT_FULLY_DISCONNECTED=OFF"
    system "cmake", ".", *cmake_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <mongocrypt/mongocrypt.h>
      int main() {
        const char* version = mongocrypt_version (0);
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lmongocrypt", "-o", "test"
    system "./test"
  end
end
