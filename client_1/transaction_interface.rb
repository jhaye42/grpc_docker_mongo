#!/usr/bin/env ruby

#Loading GRPC service
this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'calculator_services_pb'
require 'save_data_services_pb'

include Calculator
include Treatment


MULTI = [
	Params.new(nb_1: 44, nb_2: 2, op: "sub"),
	Params.new(nb_1: 3, nb_2: 2, op: "add"),
	Params.new(nb_1: 42, nb_2: 42, op: "add")
]

def main
  	stub = Transaction::Stub.new("#{ENV['CLIENT_IP']}:#{ENV['PORT_GRPC']}", :this_channel_is_insecure)

	# Simple message
	sleep 1
	p "Calc 2 + 3"
	r2 = stub.one(Params.new(nb_1: 2, nb_2: 3, op: "add"))
	p "The result is : #{r2.result}"

	sleep 1
	p "Calc 3 - 2"
	r2 = stub.one(Params.new(nb_1: 3, nb_2: 2, op: "sub"))
	p "The result is : #{r2.result}"

	sleep 1
	p "Calc 2 * 3"
	r2 = stub.one(Params.new(nb_1: 2, nb_2: 3, op: "mult"))
	p "The result is : #{r2.result}"


	# Bidirectional message - Issue for the moment with docker
	p '-----------------'
	sleep 1
	p "Multi operation"
	resps = stub.one_by_one(MULTI)
	# resps.inspect
	result_calc = 0
	resps.each do |t| 
		p "The result is : #{t.result}"
		result_calc += t.result
	end

	stub2 = SaveMongo::Stub.new("#{ENV['CLIENT_IP']}:#{ENV['PORT_GRPC']}", :this_channel_is_insecure)

	sleep 1
	p "Save result into mongo"
	r2 = stub2.save(ParamsSave.new(data: result_calc))
	p "Result saved ? #{r2.saved}"
	p "Result saved is #{r2.result}"

	sleep 1
	p "Well done !"

end

main