require 'savon'
require 'httpi'

class Geti::Client
  def initialize(auth, terminal_opts, env='test')
    @user = auth[:user]
    @pass = auth[:pass]
    @env = env
  end

  def soap_client
    @soap_client ||= Savon.client(service_address)
  end

  def soap_request(operation)
    operation.sub!('Certification','') unless certification?
    response = soap_client.request operation do
      http.headers.delete('SOAPAction')
      config.soap_header = soap_header
      xml = Builder::XmlMarkup.new
      xml.instruct!
      yield xml if block_given?
      content = xml.target!
      soap.body = {"DataPacket" => content}
    end

    op_key = operation.gsub(/(.)([A-Z])/, '\1_\2').downcase
    response_key = (op_key+'_response').to_sym
    result_key = (op_key+'_result').to_sym

    Nori.parse(response.body[response_key][result_key])
  end

  def certification?
    @env != 'production'
  end
end