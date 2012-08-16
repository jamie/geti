require 'ostruct'

class Geti::Response
  attr_reader :validation, :authorization

  def initialize(response)
    @validation = OpenStruct.new(response[:response][:validation_message])
    @authorization = OpenStruct.new(response[:response][:authorization_message])
  end

  def errors
    return [] unless validation.validation_error
    Array(validation.validation_error).map{|err|
      err[:message]
    }
  end

  def success?
    validation.result == "Passed"
  end
end
