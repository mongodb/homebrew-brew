class Libmongocrypt < Formula
  desc "C library for Client Side Encryption"
  homepage "https://github.com/mongodb/libmongocrypt"
  url "https://github.com/mongodb/libmongocrypt/archive/1.3.0.tar.gz"
  sha256 "e32550468b4be1d24c0a228a7b49cd586571391f65f434a49ab2bf736ec55d11"
  license "Apache-2.0"
  head "https://github.com/mongodb/libmongocrypt.git"

  depends_on "cmake" => :build
  depends_on "mongo-c-driver" => :build

  def install
    cmake_args = std_cmake_args
    cmake_args << if build.head?
      "-DBUILD_VERSION=1.4.0-pre"
    else
      "-DBUILD_VERSION=1.3.0"
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
