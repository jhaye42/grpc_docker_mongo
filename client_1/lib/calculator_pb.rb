# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: calculator.proto

require 'google/protobuf'

Google::Protobuf::DescriptorPool.generated_pool.build do
  add_message "calculator.Params" do
    optional :nb_1, :int32, 1
    optional :nb_2, :int32, 2
    optional :op, :string, 3
  end
  add_message "calculator.Result" do
    optional :result, :int32, 1
  end
end

module Calculator
  Params = Google::Protobuf::DescriptorPool.generated_pool.lookup("calculator.Params").msgclass
  Result = Google::Protobuf::DescriptorPool.generated_pool.lookup("calculator.Result").msgclass
end
