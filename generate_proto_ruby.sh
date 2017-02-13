#!/usr/bin/env bash

# Require install : (macos : https://github.com/grpc/homebrew-grpc) + gem install grpc + gem install google-protobuf
# After Generate proto files into server_1 & client_1, required by ruby
protoc -I protos --ruby_out=client_1/lib --grpc_out=client_1/lib --plugin=protoc-gen-grpc=`which grpc_ruby_plugin` protos/*;
protoc -I protos --ruby_out=server_1/lib --grpc_out=server_1/lib --plugin=protoc-gen-grpc=`which grpc_ruby_plugin` protos/*;