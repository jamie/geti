require 'savon'
require 'httpi'

class Geti::Client
  def initialize(auth, terminal_opts)
    @user = auth[:user]
    @pass = auth[:pass]

    @sec_code = terminal_opts[:sec_code]
    @verify_check = terminal_opts[:verify].include? :check
    @verify_id = terminal_opts[:verify].include? :identity
    @dl_required = terminal_opts[:verify].include? :dl
  end

  def get_certification_terminal_settings
    soap_request "GetCertificationTerminalSettings" do |xml|
      xml.AUTH_GATEWAY(:REQUEST_ID => 123) do
        xml.TRANSACTION do
          xml.TRANSACTION_ID
          xml.MERCHANT do
            xml.TERMINAL_ID
          end
          xml.PACKET do
            xml.IDENTIFIER
            xml.ACCOUNT do
              xml.ROUTING_NUMBER
              xml.ACCOUNT_NUMBER
              xml.ACCOUNT_TYPE
            end
            xml.CONSUMER do
              xml.FIRST_NAME
              xml.LAST_NAME
              xml.ADDRESS1
              xml.ADDRESS2
              xml.CITY
              xml.STATE
              xml.ZIP
              xml.PHONE_NUMBER
              xml.DL_STATE
              xml.DL_NUMBER
              xml.COURTESY_CARD_ID
            end
            xml.CHECK do
              xml.CHECK_AMOUNT
            end
          end
        end
      end
    end
  end


  def soap_client
    @soap_client ||= Savon.client("https://demo.eftchecks.com/webservices/AuthGateway.asmx?WSDL")
  end

  def soap_header
    { "AuthGatewayHeader" => {
        "UserName" => @user,
        "Password" => @pass,
        "TerminalID" => terminal_id.to_s
      },
      :attributes! => { 'AuthGatewayHeader' => {'xmlns'=>"http://tempuri.org/GETI.eMagnus.WebServices/AuthGateway"}}
    }
  end

  def soap_request(operation)
    response = soap_client.request operation do
      http.headers.delete('SOAPAction')
      config.soap_header = soap_header
      xml = Builder::XmlMarkup.new
      xml.instruct!
      yield xml
      content = xml.target!
      soap.body = {"DataPacket" => content}
    end

    op_key = operation.gsub(/(.)([A-Z])/, '\1_\2').downcase
    response_key = (op_key+'_response').to_sym
    result_key = (op_key+'_result').to_sym

    Nori.parse(response.body[response_key][result_key])
  end

  def terminal_id
    base = {
      'PPD' => 1010,
      'WEB' => 2310
    }[@sec_code]
    offset = {
      [false, false, false] => 0,
      [true,  false, false] => 1,
      [false, true,  true ] => 2,
      [true,  true,  true ] => 3,
      [false, true,  false] => 4,
      [true,  true,  false] => 5,
      [false, false, true ] => 6,
      [true,  false, true ] => 7
    }[[@dl_required, @verify_check, @verify_id]]
    base + offset
  end
end