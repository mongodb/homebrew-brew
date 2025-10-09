class Libmongocrypt < Formula
  desc "C library for Client Side Encryption"
  homepage "https://github.com/mongodb/libmongocrypt"
  url "https://github.com/mongodb/libmongocrypt/archive/1.16.0.tar.gz"
  sha256 "02da03521fd45674297a1fe24a1f63f5360dc127ecf2a54b446e6e7fcc29919f"
  license "Apache-2.0"
  head "https://github.com/mongodb/libmongocrypt.git"

  depends_on "cmake" => :build

  def install
    cmake_args = std_cmake_args
    cmake_args << if build.head?
      "-DBUILD_VERSION=1.17.0-pre"
    else
      "-DBUILD_VERSION=1.16.0"
    end

    cmake_args << "-DENABLE_ONLINE_TESTS=OFF"
    # Homebrew includes FETCHCONTENT_FULLY_DISCONNECTED=ON as part of https://github.com/Homebrew/brew/pull/17075
    # Set back the previous default to prevent build failure.
    cmake_args << "-DFETCHCONTENT_FULLY_DISCONNECTED=OFF"
    # TODO(MONGOCRYPT-854): Use mongo-c-driver package rather than auto-download.
    # Allow FetchContent to build the bundled IntelDFP tarball and auto-download the C driver.
    cmake_args << "-DHOMEBREW_ALLOW_FETCHCONTENT=ON"

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
