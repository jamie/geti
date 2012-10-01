require 'helper'

def routing_number(type)
  { :authorization  => 490000018,
    :decline        => 490000034,
    :manager_needed => 490000021,
    :represented    => 490000047
  }[type]
end

describe Geti::AuthClient do
  describe '#get_terminal_settings' do
    it 'gets a successful WEB response' do
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      terminal_settings = client.get_terminal_settings
      terminal_settings.terminal_id.must_equal "2310"
    end

    it 'gets a successful PPD response' do
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'PPD', :verify => []})
      terminal_settings = client.get_terminal_settings
      terminal_settings.terminal_id.must_equal "1010"
    end

    it 'gets a restricted WEB response' do
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'WEB', :verify => [:dl]})
      terminal_settings = client.get_terminal_settings
      terminal_settings.terminal_id.must_equal "2311"
    end
  end

  describe '#validate' do
    it 'gets a failed WEB response' do
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      response = client.validate({})
      response.validation.result.must_equal "Failed"
      response.wont_be :success?
      response.errors.must_include "The 'CHECK_AMOUNT' element has an invalid value according to its data type."
    end

    it 'gets a successful WEB response' do
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      response = client.validate({
        :type => :authorize,
        :amount => 1000,
        :first_name => 'Bob',
        :last_name => 'Smith',
        :account_type => 'Checking',
        :routing_number => '123456778',
        :account_number => '1234567890'
      })
      response.validation.result.must_equal "Passed"
      response.must_be :success?
      response.errors.must_be_empty
    end
  end

  describe '#process' do
    it 'gets a failed WEB response' do
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      response = client.process({})
      response.validation.result.must_equal "Failed"
      response.wont_be :success?
      response.errors.must_include "The 'CHECK_AMOUNT' element has an invalid value according to its data type."
    end

    it 'gets an exception' do
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      response = client.process({
        :type => :authorize,
        :amount => 1000,
        :first_name => 'Bob',
        :last_name => 'Smith',
        :account_type => 'Checking',
        :routing_number => '123456778',
        :account_number => '1234567890'
      })
      response.wont_be :success?
      response.exception.message.wont_be_empty
    end

    it 'gets a successful WEB response' do
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      response = client.process({
        :type => :authorize,
        :amount => 1000,
        :first_name => 'Bob',
        :last_name => 'Smith',
        :account_type => 'Checking',
        :routing_number => routing_number(:authorization),
        :account_number => '1234567890'
      })
      response.validation.result.must_equal "Passed"
      response.must_be :success?
      response.errors.must_be_empty
      response.authorization.message.must_equal "APPROVAL"
    end
  end
end
