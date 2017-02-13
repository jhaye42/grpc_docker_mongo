# Required

require 'mongoid'

class Result42
  include Mongoid::Document

  field :result, type: Integer
end
