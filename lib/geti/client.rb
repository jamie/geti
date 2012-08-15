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
    response = soap_client.request "GetCertificationTerminalSettings" do
      http.headers.delete('SOAPAction')
      config.soap_header = soap_header
      content = <<-XML.gsub(/(^|\n) +/, '')
        <?xml version="1.0" encoding="utf-8"?>
        <AUTH_GATEWAY REQUEST_ID="123">
          <TRANSACTION>
            <TRANSACTION_ID/>
            <MERCHANT>
              <TERMINAL_ID/>
            </MERCHANT>
            <PACKET>
              <IDENTIFIER/>
              <ACCOUNT>
                <ROUTING_NUMBER/>
                <ACCOUNT_NUMBER/>
                <ACCOUNT_TYPE/>
              </ACCOUNT>
              <CONSUMER>
                <FIRST_NAME/>
                <LAST_NAME/>
                <ADDRESS1/>
                <ADDRESS2/>
                <CITY/>
                <STATE/>
                <ZIP/>
                <PHONE_NUMBER/>
                <DL_STATE/>
                <DL_NUMBER/>
                <COURTESY_CARD_ID/>
              </CONSUMER>
              <CHECK>
                <CHECK_AMOUNT/>
              </CHECK>
            </PACKET>
          </TRANSACTION>
        </AUTH_GATEWAY>
      XML
      soap.body = {"DataPacket" => content}
    end

    result = response.body[:get_certification_terminal_settings_response][:get_certification_terminal_settings_result]
#    pp Nori.parse(result)
    Nori.parse(result)
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