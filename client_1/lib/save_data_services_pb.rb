# Generated by the protocol buffer compiler.  DO NOT EDIT!
# Source: save_data.proto for package 'treatment'

require 'grpc'
require 'save_data_pb'

module Treatment
  module SaveMongo
    class Service

      include GRPC::GenericService

      self.marshal_class_method = :encode
      self.unmarshal_class_method = :decode
      self.service_name = 'treatment.SaveMongo'

      rpc :save, ParamsSave, ResultSave
    end

    Stub = Service.rpc_stub_class
  end
end