require 'spec_helper'
require 'savon/mock/spec_helper'

describe Geti::AuthClient do
  include Savon::SpecHelper
  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

  describe '#get_terminal_settings' do
    it 'calls GetCertificationTerminalSettings' do
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      savon.expects(:get_certification_terminal_settings).returns(fixture(:get_certification_terminal_settings))
      client.get_terminal_settings
    end

    it 'calls GetTerminalSettings in production' do
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'WEB', :verify => []}, 'production')
      savon.expects(:get_terminal_settings).returns(fixture(:get_terminal_settings))
      client.get_terminal_settings
    end
  end
end
