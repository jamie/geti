require 'helper'

describe Geti::AuthClient do
  def mock_soap!(client, parsed_response, operation, op_key=nil)
    op_key ||= operation.gsub(/(.)([A-Z])/, '\1_\2').downcase
    response_key = (op_key+'_response').to_sym
    result_key = (op_key+'_result').to_sym

    data = OpenStruct.new(:body => {response_key => {result_key => :encoded_xml}})

    client.soap_client.should_receive(:request).with(operation).and_return(data)
    client.xml_parser.should_receive(:parse).with(:encoded_xml).and_return(parsed_response)
  end

  describe '#get_terminal_settings' do
    it 'calls GetCertificationTerminalSettings' do
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'WEB', :verify => []})
      mock_soap!(client, {}, "GetCertificationTerminalSettings")
      client.get_terminal_settings
    end

    it 'calls GetTerminalSettings in production' do
      client = Geti::AuthClient.new(test_credentials, {:sec_code => 'WEB', :verify => []}, 'production')
      mock_soap!(client, {}, "GetTerminalSettings")
      client.get_terminal_settings
    end
  end
end
