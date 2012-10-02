class Geti::AppClient < Geti::Client

  def board_merchant_ach(application)
    response = soap_request("BoardCertificationMerchant_ACH", "board_certification_merchant_ach") do |xml|
      data_packet(xml, application)
    end
  end

  def data_packet(xml, opts)
    xml.Envelope do
      xml.Body :FileName => "261407_28_May_2009_12_05_00_590.xml", :FileDate => Time.now.iso8601 do
        xml.NewMerchant({
          :isoID => "9999",
          :merchCrossRefID => opts[:id],
          :merchName => "Test Merchant ACH 1",
          :merchTypeID => "49",
          :merchServiceType => "GOLD",
          :merchAddress1 => "123 Main Street",
          :merchCity => "Destin",
          :merchState => "FL",
          :merchZip => "32541",
          :merchPhone => "1231231234",
          :merchAchFlatFee => "0.29",
          :merchNonAchFlatFee => "0.29",
          :merchPercentFee => "1.89",
          :merchComments => "Food market",
          :merchReturnFee => "1.00"
        }) do
          xml.BusinessInfo({
            :merchOwnership => 3,
            :merchAvgCheckAmount => "50.00",
            :merchMaxCheckAmount => "200.00",
            :merchTotalTimeInBusiness => "456"
          })
          xml.NewLocation({
            :locName => "Test Merchant",
            :locCrossRefID => "261407",
            :locAddress1 => "123 Main Street",
            :locCity => "Destin",
            :locState => "FL",
            :locZip => "32541",
            :locPhone => "1231231234",
            :locStatementFee => "10.00",
            :locMinimumFee => "25.00",
            :locFeesRoutingNum => "490000018",
            :locFeesAccountNum => "123456789"
          }) do
            xml.Statement({
              :locStatementAddress1 => "PO Box 1234",
              :locStatementCity => "Destin",
              :locStatementState => "FL",
              :locStatementZip => "32541",
              :locStatementAttn => "Garey Larrabee",
            })
            xml.NewPOC({
              :pocPrimary => "1",
              :pocFirstName => "John",
              :pocLastName => "Doe",
              :pocTitle => "Owner",
              :pocComments => "",
              :pocAddress => "123 Main Street",
              :pocCity => "Destin",
              :pocState => "FL",
              :pocZip => "32541",
              :pocDOB => "1945-10-26",
              :pocSSN => "123121111",
            })
            xml.NewTerminal({
              :termCrossRefID => "41680",
              :termCheckLimit => "500.00",
              :termPeripheral => "63",
              :termTypeID => "16",
              :termVerificationOnly => "0",
            })
            xml.NewTerminal({
              :termCrossRefID => "53317",
              :termCheckLimit => "500.00",
              :termPeripheral => "63",
              :termTypeID => "172",
              :termVerificationOnly => "0",
            })
            xml.NewTerminal({
              :termCrossRefID => "296223",
              :termCheckLimit => "500.00",
              :termPeripheral => "63",
              :termTypeID => "637",
              :termVerificationOnly => "0",
            })
            xml.NewTerminal({
              :termCrossRefID => "296228",
              :termCheckLimit => "500.00",
              :termPeripheral => "63",
              :termTypeID => "16",
              :termVerificationOnly => "0",
            })
            xml.NewTerminal({
              :termCrossRefID => "296225",
              :termCheckLimit => "500.00",
              :termPeripheral => "63",
              :termTypeID => "637",
              :termVerificationOnly => "0",
            })
          end
        end
      end
    end
  end

  def service_address
    "https://demo.eftchecks.com/webservices/AppGateway.asmx?WSDL"
  end

  def soap_header
    { "RemoteAccessHeader" => {
        "UserName" => @user,
        "Password" => @pass
      },
      :attributes! => { "RemoteAccessHeader" => {"xmlns"=>"http://tempuri.org/GETI.eMagnus.WebServices/AppGateway"}}
    }
  end
end
