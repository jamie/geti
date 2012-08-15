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
  end
end
