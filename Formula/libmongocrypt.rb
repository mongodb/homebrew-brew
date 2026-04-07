class Libmongocrypt < Formula
  desc "C library for Client Side Encryption"
  homepage "https://github.com/mongodb/libmongocrypt"
  url "https://github.com/mongodb/libmongocrypt/archive/1.17.3.tar.gz"
  sha256 "12b304874046399ad6567ceba426260bf06a4e1c2974b460a1b1f04b89c86ed5"
  license "Apache-2.0"
  head "https://github.com/mongodb/libmongocrypt.git"

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args
    cmake_args << if build.head?
      "-DBUILD_VERSION=1.18.0-pre"
    else
      "-DBUILD_VERSION=1.17.3"
    end

    cmake_args << "-DENABLE_ONLINE_TESTS=OFF"
    # Homebrew includes FETCHCONTENT_FULLY_DISCONNECTED=ON as part of https://github.com/Homebrew/brew/pull/17075
    # Set back the previous default to prevent build failure.
    cmake_args << "-DFETCHCONTENT_FULLY_DISCONNECTED=OFF"
    # TODO(MONGOCRYPT-854): Use mongo-c-driver package rather than auto-download.
    # Allow FetchContent to build the bundled IntelDFP tarball and auto-download the C driver.
    cmake_args << "-DHOMEBREW_ALLOW_FETCHCONTENT=ON"
    # Do not build 'all' target, to skip building unnecessary tests.
    cmake_args << "-DCMAKE_SKIP_INSTALL_ALL_DEPENDENCY=ON"

    system "cmake", ".", *cmake_args
    # Build minimal targets needed for install:
    system "make", "mongocrypt", "mongocrypt_static", "kms_message", "kms_message_static"
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
