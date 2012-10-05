require 'helper'

class Geti::Client
  def stub_soap_client!(client)
    @soap_client = client
  end
end

def get_certification_terminal_settings_response
  OpenStruct.new(:body => {
    :get_certification_terminal_settings_response => {
      :get_certification_terminal_settings_result => {}
    }
  })
end

def get_terminal_settings_response
  OpenStruct.new(:body => {
    :get_terminal_settings_response => {
      :get_terminal_settings_result => {}
    }
  })
end

describe Geti::AuthClient do
  before do
    @soap_mock = MiniTest::Mock.new
  end

  describe '#get_terminal_settings' do
    it 'calls GetCertificationTerminalSettings' do
      @soap_mock.expect(:request, get_certification_terminal_settings_response, ["GetCertificationTerminalSettings"])
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      client.stub_soap_client!(@soap_mock)
      client.get_terminal_settings
    end

    it 'calls GetTerminalSettings in production' do
      @soap_mock.expect(:request, get_terminal_settings_response, ["GetTerminalSettings"])
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'WEB', :verify => []}, 'production')
      client.stub_soap_client!(@soap_mock)
      client.get_terminal_settings
    end
  end
end
