class Geti::AppClient < Geti::Client
  def service_address
    "https://demo.eftchecks.com/webservices/AppGateway.asmx"
  end

  def soap_header
    { "AppGatewayHeader" => {
        "UserName" => @user,
        "Password" => @pass
      },
      :attributes! => { 'AppGatewayHeader' => {'xmlns'=>"http://tempuri.org/GETI.eMagnus.WebServices/AppGateway"}}
    }
  end
end
