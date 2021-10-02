class ProtocGenGrpcJava < Formula
  desc "Protoc plugin that generates code for gRPC-Java clients"
  homepage "https://github.com/grpc/grpc-java"
  version "1.41.0"
  url "https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/1.41.0/protoc-gen-grpc-java-1.41.0-osx-x86_64.exe"
  sha256 "f92859e25646f0db33b9b542a07053ebf2569304abf18338c9e6f75ec8993b0d"
  license "Apache-2.0"

  livecheck do
    url "https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/"
    regex(%r{https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/?(\d+(?:\.\d+)+)/}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:       "f92859e25646f0db33b9b542a07053ebf2569304abf18338c9e6f75ec8993b0d"
    sha256 cellar: :any_skip_relocation, catalina:      "f92859e25646f0db33b9b542a07053ebf2569304abf18338c9e6f75ec8993b0d"
    sha256 cellar: :any_skip_relocation, mojave:        "f92859e25646f0db33b9b542a07053ebf2569304abf18338c9e6f75ec8993b0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0d1842fe12dcde7df9588b5a6a682e7da4cf329bbf1a98303a8c6ee126481e42"
  end

  depends_on "protobuf"

  resource "protoc-gen-grpc-java" do
    on_linux do
      version = Formula.version
      url "https://repo1.maven.org/maven2/io/grpc/protoc-gen-grpc-java/1.41.0/protoc-gen-grpc-java-1.41.0-linux-x86_64.exe"
      sha256 "0d1842fe12dcde7df9588b5a6a682e7da4cf329bbf1a98303a8c6ee126481e42"
    end
  end

  def install
    if OS.mac?
      bin.install "protoc-gen-grpc-java-1.41.0-osx-x86_64.exe" => "protoc-gen-grpc-java"
    else
      bin.install "protoc-gen-grpc-java-1.41.0-linux-x86_64.exe" => "protoc-gen-grpc-java"
    end
  end

  test do
    (testpath/"service.proto").write <<~EOS
      syntax = "proto3";

      option java_package = "com.example.helloworld";

      service Greeter {
        rpc Hello(HelloRequest) returns (HelloResponse);
      }

      message HelloRequest {}
      message HelloResponse {}
    EOS

    system "protoc", "--plugin=#{bin}/protoc-gen-grpc-java", "--grpc-java_out=.", "service.proto"

    assert_predicate testpath/"com/example/helloworld/GreeterGrpc.java", :exist?
  end
end
