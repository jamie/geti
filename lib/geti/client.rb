require 'savon'
require 'httpi'

class Geti::Client
  def initialize(auth, terminal_opts={}, env='test')
    @user = auth[:user]
    @pass = auth[:pass]
    @env = env
  end

  def soap_client
    @soap_client ||= Savon.client(service_address)
  end

  def data_packet
    xml = Builder::XmlMarkup.new
    xml.instruct!
    yield xml
    content = xml.target!
    {"DataPacket" => content}
  end

  def soap_request(operation, op_key=nil)
    operation.sub!('Certification','') unless certification?
    response = soap_client.request operation do
      http.headers.delete('SOAPAction')
      config.soap_header = soap_header
      soap.body = (yield if block_given?)
    end

    op_key ||= operation.gsub(/(.)([A-Z])/, '\1_\2').downcase
    operation.sub!('_certification','') unless certification?
    response_key = (op_key+'_response').to_sym
    result_key = (op_key+'_result').to_sym

    xml_parser.parse(response.body[response_key][result_key])
  end

  def certification?
    @env != 'production'
  end

  def xml_parser
    @xml_parser or Nori
  end
end