#!/usr/bin/env ruby

# Loading GRPC service
this_dir = File.expand_path(File.dirname(__FILE__))
lib_dir = File.join(this_dir, 'lib')
$LOAD_PATH.unshift(lib_dir) unless $LOAD_PATH.include?(lib_dir)

require 'calculator_services_pb'
require 'save_data_services_pb'

include Calculator
include Treatment


# Loading mongoid models
require 'mongoid'

Dir["#{File.join(this_dir, 'models')}/*.rb"].each {|file| require file }
Mongoid.load!(File.join(this_dir, ENV['MONGOID_CONF_PATH']), :development)


class EnumeratorQueue
  extend Forwardable
  def_delegators :@q, :push

  def initialize(sentinel)
    @q = Queue.new
    @sentinel = sentinel
  end

  def each_item
    return enum_for(:each_item) unless block_given?
    loop do
      r = @q.pop
      break if r.equal?(@sentinel)
      fail r if r.is_a? Exception
      yield r
    end
  end
end


def interface_transaction(nb1, nb2, op)
  if op == "add"
    result = nb1 + nb2
  elsif op == "sub"
    result = nb1 - nb2
  elsif op == "mult"
    result = nb1 * nb2
  end

  Result.new(result: result)
end


def calcule_transaction(nb1, nb2, op)
  if op == "add"
    result = nb1 + nb2
  elsif op == "sub"
    result = nb1 - nb2
  elsif op == "mult"
    result = nb1 * nb2
  end

  result
end


class CalculatorServer < Transaction::Service

  # Multi stream
	def one_by_one(req)
    p 'Multi entry'
		q = EnumeratorQueue.new(self)

		t = Thread.new do
		  begin
		    req.each { |n| q.push(interface_transaction(n.nb_1, n.nb_2, n.op)) }
			  q.push(self)
		  rescue StandardError => e
        q.push(e)
	    end
    end
		q.each_item
  end

  # Simple
  def multi(req)
    p 'One By One entry with params: ' + req.inspect
    result = 0
    req.each do |n|
      result += calcule_transaction(n.nb_1, n.nb_2, n.op)
    end
    Result.new(result: result)
  end

  # Simple
  def one(req, _unused_call)
    p 'Simple entry with params: ' + req.inspect
    interface_transaction(req.nb_1, req.nb_2, req.op)
  end

end


class DataSaveServer < SaveMongo::Service

  # Simple
  def save(req, _unused_call)
    p 'Save result into mongo with params: ' + req.inspect
    saved = Result42.new(result: req.data).save
    ResultSave.new(result: req.data, saved: saved)
  end

end


# Server
def main
  s = GRPC::RpcServer.new
  s.add_http2_port("#{ENV['SERVER_IP']}:#{ENV['PORT_GRPC']}", :this_port_is_insecure)
  s.handle(CalculatorServer) #1st service - Calculator
  s.handle(DataSaveServer) #2nd service - SaveData
  s.run_till_terminated
end

main

