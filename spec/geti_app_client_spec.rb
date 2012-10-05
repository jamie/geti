require 'helper'

class Geti::Client
  def stub_soap_client!(client)
    @soap_client = client
  end
end

describe Geti::AppClient do
  before do
    @soap_mock = MiniTest::Mock.new
  end

  def request_payload
    {
      :id               => 123456,
      :name             => "Cogsley's Cogs",
      :industry         => "Metal_Fabricators",
      :address          => "123 Main St",
      :city             => "Vancouver",
      :state            => "WA",
      :zip              => "10120",
      :phone            => "5555551234",
      :business_type    => "Corporation",
      :days_in_business => 404,

      :contact_name     => 'George Jetson',
      :physical_address => "123 Main St",
      :physical_city    => "Vancouver",
      :physical_state   => "WA",
      :physical_zip     => "10120",
      :physical_phone   => "5555551234",

      :principal_first_name => "Carl",
      :principal_last_name  => "Cogsley",
      :principal_title      => 'President',
      :principal_address    => "123 Main St",
      :principal_city       => "Vancouver",
      :principal_state      => "WA",
      :principal_zip        => "10120",
      :principal_dob        => "1965-04-28",
      :principal_ssn        => '111222123',

      :average_amount       => "4000",
      :max_amount           => "7600",

      :taxpayer_name => "Carl Cogsley",
      :taxpayer_id   => "123456789",

      :routing_number => "490000018",
      :account_number => "123456789",
    }
  end

  def success_response
    OpenStruct.new(:body => {
      :board_certification_merchant_ach_response => {
        :board_certification_merchant_ach_result => {
#          :status=>"Approved",
          #    :message=>
          #     "1 merchant(s) created.\n0 merchant(s) not created due to errors.\n\n-----------------------\nMerchants Created:\nCogsley's Cogs (ISO ID: 9999, CrossRef: 123456, Status: AppApprovedandActivated)\n\n",
          #    :app_data=>
          #     {:merchant=>
          #       {:@name=>"Cogsley's Cogs",
          #        :@active=>"1",
          #        :@type=>"Merchant",
          #        :@cross_ref_id=>"123456",
          #        :@id=>"20",
          #        :location=>
          #         {:terminal=>
          #           {:@manual_entry=>"N",
          #            :@name=>"Lipman Nurit 3000-01 (111163) ",
          #            :@active=>"1",
          #            :@type=>"Terminal",
          #            :@cross_ref_id=>"41680",
          #            :@id=>"111163",
          #            :@mid=>"101-111163-606"},
          #          :@name=>"Cogsley's Cogs ",
          #          :@active=>"1",
          #          :@ach_name=>"COGSLEYSCOGS",
          #          :@type=>"Location",
          #          :@cross_ref_id=>"123456",
          #          :@id=>"31"},
          #        :poc1=>
          #         {:@password=>"UGPRDGIX",
          #          :@user_name=>"CCogsley",
          #          :@last_name=>"Cogsley",
          #          :@first_name=>"Carl"}}},
          #    :"@xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema",
          #    :"@xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
          #    :validation_message=>{:result=>"Passed", :schema_file_path=>nil}
        }
      }
    })
  end

  def error_response
    # error_response = {:"@xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema",
    #   :"@xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
    #   :validation_message=>
    #    {:result=>"Failed",
    #     :schema_file_path=>
    #      "http://demo.eftchecks.com/WebServices/schemas/app/NewMerchApp_ACH.xsd",
    #     :validation_error=>
    #      [{:@line_number=>"1",
    #        :severity=>"Error",
    #        :message=>"The 'pocAddress1' attribute is not declared.",
    #        :@line_position=>"1193"},
    #       {:@line_number=>"1",
    #        :severity=>"Error",
    #        :message=>"The required attribute 'pocAddress' is missing.",
    #        :@line_position=>"1020"}]}}
  end

  def repeat_response
    # repeat_response = {:status=>"Pending",
    #   :message=>
    #    "1 merchant(s) created.\n0 merchant(s) not created due to errors.\n\n-----------------------\nMerchants Created:\nCogsley's Cogs (ISO ID: 9999, CrossRef: 123456, Status: PendingInput)\n\n",
    #   :validation_message=>{:result=>"Passed", :schema_file_path=>nil},
    #   :"@xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema",
    #   :"@xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
    #   :app_data=>{:merchant=>{:@id=>"21"}}}
    # 
  end

  describe '#board_merchant_ach' do
    it 'calls BoardCertificationMerchant_ACH' do
      @soap_mock.expect(:request, success_response, ["BoardCertificationMerchant_ACH"])
      client = Geti::AppClient.new(test_app_credentials, {})
      client.stub_soap_client!(@soap_mock)
      client.board_merchant_ach(request_payload)
    end

    it 'calls BoardMerchant_ACH in production' do
      @soap_mock.expect(:request, success_response, ["BoardMerchant_ACH"])
      client = Geti::AppClient.new(test_app_credentials, {}, 'production')
      client.stub_soap_client!(@soap_mock)
      client.board_merchant_ach(request_payload)
    end
  end
end
