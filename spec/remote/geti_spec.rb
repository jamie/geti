require 'helper'

describe Geti::Client do
  describe 'get_certification_terminal_settings' do
    it 'gets a successful WEB response' do
      client = Geti::Client.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      response = client.get_certification_terminal_settings
      response[:terminal_settings][:terminal_id].must_equal "2310"
    end

    it 'gets a successful PPD response' do
      client = Geti::Client.new(test_credentials, {:sec_code => 'PPD', :verify => []})
      response = client.get_certification_terminal_settings
      response[:terminal_settings][:terminal_id].must_equal "1010"
    end

    it 'gets a restricted WEB response' do
      client = Geti::Client.new(test_credentials, {:sec_code => 'WEB', :verify => [:dl]})
      response = client.get_certification_terminal_settings
      response[:terminal_settings][:terminal_id].must_equal "2311"
    end
  end

  describe 'auth_gateway_certification' do
    it 'gets a failed WEB response' do
      client = Geti::Client.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      response = client.auth_gateway_certification({})
      response[:response][:validation_message][:result].must_equal "Failed"
    end

    it 'gets a successful WEB response' do
      client = Geti::Client.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      response = client.auth_gateway_certification({
        :type => :authorize,
        :amount => 10.00,
        :first_name => 'Bob',
        :last_name => 'Smith',
        :account_type => 'Checking',
        :routing_number => '123456778',
        :account_number => '1234567890'
      })
      response[:response][:validation_message][:result].must_equal "Passed"
    end
  end
end
