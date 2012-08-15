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
    soap_request "GetCertificationTerminalSettings"
  end

  def auth_gateway_certification(opts)
    soap_request "AuthGatewayCertification" do |xml|
      xml.AUTH_GATEWAY do # has an optional REQUEST_ID for later lookups
        xml.TRANSACTION do
          xml.TRANSACTION_ID
          xml.MERCHANT do
            xml.TERMINAL_ID terminal_id
          end
          xml.PACKET do
            xml.IDENTIFIER identifier(opts[:type])
            xml.ACCOUNT do
              xml.ROUTING_NUMBER opts[:routing_number]
              xml.ACCOUNT_NUMBER opts[:account_number]
              xml.ACCOUNT_TYPE   opts[:account_type]
            end
            xml.CONSUMER do
              xml.FIRST_NAME opts[:first_name]
              xml.LAST_NAME  opts[:last_name]
              xml.ADDRESS1
              xml.ADDRESS2
              xml.CITY
              xml.STATE
              xml.ZIP
              xml.PHONE_NUMBER
              xml.DL_STATE
              xml.DL_NUMBER
              xml.COURTESY_CARD_ID
              if @verify_id
                xml.IDENTITY do
                  xml.SSN4
                  xml.DOB_YEAR
                end
              end
            end
            xml.CHECK do
              xml.CHECK_AMOUNT opts[:amount]
            end
          end
        end
      end
    end
  end


  def identifier(name)
    { :authorize => 'A',
      :void      => 'V',
      :override  => 'O',
      :payroll   => 'P',
      :recurring => 'R'
    }[name]
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
      yield xml if block_given?
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
      # Guaranteed
      'PPD' => 1010, # Debit-only
      'POP' => 1110,
      'TEL' => 1210,
      'C21' => 1610,
      'CCD' => 1710, # Debit only
      'PPD_cr' => 1810, # Debit and Credit
      'CCD_cr' => 1910, # Debit and Credit
      # Non-Guaranteed
      'PPD_ng' => 2010,
      'TEL_ng' => 2210,
      'WEB'    => 2310, # Web is always non-guaranteed
      'CCD_ng' => 2710,
      'PPD_ng_cr' => 2810,
      'CCD_ng_cr' => 2910
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