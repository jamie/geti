require 'savon'
require 'httpi'

class Geti::Client
  def initialize(auth, terminal_opts={}, env='test')
    @user = auth['user']
    @pass = auth['pass']
    @env = env
  end

  def soap_client
    Savon.client do |savon|
      savon.wsdl service_address
      savon.soap_version 2

      savon.convert_request_keys_to :camelcase
      savon.pretty_print_xml true
    end
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

    op_key ||= operation.gsub(/(.)([A-Z])/, '\1_\2').downcase
    op_key.sub!('_certification','') unless certification?
    response_key = (op_key+'_response').to_sym
    result_key = (op_key+'_result').to_sym

    geti_soap_header = soap_header
    response = soap_client.call(op_key.to_sym) do
      soap_header geti_soap_header
      message(yield) if block_given?
    end

    xml_parser.parse(response.body[response_key][result_key])
  end

  def certification?
    @env != 'production'
  end

  def domain
    if certification?
      'demo.eftchecks.com'
    else
      'getigateway.eftchecks.com'
    end
  end

  def xml_parser
    @xml_parser or Nori.new(:convert_tags_to => lambda { |tag| tag.snakecase.to_sym })
  end
end
