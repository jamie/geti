require 'ostruct'

class Geti::Response
  attr_reader :validation, :authorization, :exception

  def initialize(response)
    @validation    = OpenStruct.new(response[:response][:validation_message])
    @authorization = OpenStruct.new(response[:response][:authorization_message])
    @exception     = OpenStruct.new(response[:response][:exception])
  end

  def errors
    err = []
    Array(@validation.validation_error).each do |e|
      err << e[:message]
    end
    err << @exception.message
    err.compact
  end

  def success?
    validation.result == "Passed"
  end
end
