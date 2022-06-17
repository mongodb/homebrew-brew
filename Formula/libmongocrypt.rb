class Libmongocrypt < Formula
  desc "C library for Client Side Encryption"
  homepage "https://github.com/mongodb/libmongocrypt"
  url "https://github.com/mongodb/libmongocrypt/archive/1.4.1.tar.gz"
  sha256 "15f118ac42a9df9dd86af2d93bd763bbc128977b73cfd430cb1d6270350e344e"
  license "Apache-2.0"
  head "https://github.com/mongodb/libmongocrypt.git", tag: "1.5.0-rc1"

  depends_on "cmake" => :build
  depends_on "mongo-c-driver" => :build

  def install
    cmake_args = std_cmake_args
    cmake_args << if build.head?
      "-DBUILD_VERSION=1.5.0-rc1"
    else
      "-DBUILD_VERSION=1.4.1"
    end
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
