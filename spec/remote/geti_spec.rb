require 'helper'

describe Geti::Client do
  describe '#get_terminal_settings' do
    it 'gets a successful WEB response' do
      client = Geti::Client.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      terminal_settings = client.get_terminal_settings
      terminal_settings.terminal_id.must_equal "2310"
    end

    it 'gets a successful PPD response' do
      client = Geti::Client.new(test_credentials, {:sec_code => 'PPD', :verify => []})
      terminal_settings = client.get_terminal_settings
      terminal_settings.terminal_id.must_equal "1010"
    end

    it 'gets a restricted WEB response' do
      client = Geti::Client.new(test_credentials, {:sec_code => 'WEB', :verify => [:dl]})
      terminal_settings = client.get_terminal_settings
      terminal_settings.terminal_id.must_equal "2311"
    end
  end

  describe '#auth_gateway_certification' do
    it 'gets a failed WEB response' do
      client = Geti::Client.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      response = client.auth_gateway_certification({})
      response.validation.result.must_equal "Failed"
      response.wont_be :success?
      
      response.errors.must_include "The 'CHECK_AMOUNT' element has an invalid value according to its data type."
    end

    it 'gets a successful WEB response' do
      client = Geti::Client.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      response = client.auth_gateway_certification({
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
end
