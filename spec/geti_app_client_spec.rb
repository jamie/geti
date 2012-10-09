require 'helper'

describe Geti::AppClient do
  def mock_soap!(client, parsed_response, operation, op_key=nil)
    op_key ||= operation.gsub(/(.)([A-Z])/, '\1_\2').downcase
    response_key = (op_key+'_response').to_sym
    result_key = (op_key+'_result').to_sym

    data = OpenStruct.new(:body => {response_key => {result_key => :encoded_xml}})

    client.soap_client.should_receive(:request).with(operation).and_return(data)
    client.xml_parser.should_receive(:parse).with(:encoded_xml).and_return(parsed_response)
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
    {:response=>{
      :status=>"Approved",
      :message=>"1 merchant(s) created.\n0 merchant(s) not created due to errors.\n\n-----------------------\nMerchants Created:\nCogsley's Cogs (ISO ID: 9999, CrossRef: 123456, Status: AppApprovedandActivated)\n\n",
      :app_data=>{
        :merchant=>{
          :@name=>"Cogsley's Cogs",
          :@active=>"1",
          :@type=>"Merchant",
          :@cross_ref_id=>"123456",
          :@id=>"20",
          :location=>{
            :terminal=>{
              :@manual_entry=>"N",
              :@name=>"Lipman Nurit 3000-01 (111163) ",
              :@active=>"1",
              :@type=>"Terminal",
              :@cross_ref_id=>"41680",
              :@id=>"111163",
              :@mid=>"101-111163-606"},
            :@name=>"Cogsley's Cogs ",
            :@active=>"1",
            :@ach_name=>"COGSLEYSCOGS",
            :@type=>"Location",
            :@cross_ref_id=>"123456",
            :@id=>"31"},
          :poc1=>{
            :@password=>"UGPRDGIX",
            :@user_name=>"CCogsley",
            :@last_name=>"Cogsley",
            :@first_name=>"Carl"}}},
      :"@xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema",
      :"@xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
      :validation_message=>{:result=>"Passed", :schema_file_path=>nil}}}
  end

  def error_response
    {:response=>{
      :"@xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema",
      :"@xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
      :validation_message=>
       {:result=>"Failed",
        :schema_file_path=>
         "http://demo.eftchecks.com/WebServices/schemas/app/NewMerchApp_ACH.xsd",
        :validation_error=>
         [{:@line_number=>"1",
           :severity=>"Error",
           :message=>"The 'pocAddress1' attribute is not declared.",
           :@line_position=>"1193"},
          {:@line_number=>"1",
           :severity=>"Error",
           :message=>"The required attribute 'pocAddress' is missing.",
           :@line_position=>"1020"}]}}}
  end

  def repeat_response
    {:response=>{
      :status=>"Pending",
      :message=>
       "1 merchant(s) created.\n0 merchant(s) not created due to errors.\n\n-----------------------\nMerchants Created:\nCogsley's Cogs (ISO ID: 9999, CrossRef: 123456, Status: PendingInput)\n\n",
      :validation_message=>{:result=>"Passed", :schema_file_path=>nil},
      :"@xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema",
      :"@xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
      :app_data=>{:merchant=>{:@id=>"21"}}}}
  end

  describe '#board_merchant_ach' do
    it 'calls BoardCertificationMerchant_ACH' do
      client = Geti::AppClient.new(test_app_credentials, {})
      mock_soap!(client, success_response, "BoardCertificationMerchant_ACH", "board_certification_merchant_ach")
      client.board_merchant_ach(request_payload)
    end

    it 'calls BoardMerchant_ACH in production' do
      client = Geti::AppClient.new(test_app_credentials, {}, 'production')
      mock_soap!(client, success_response, "BoardMerchant_ACH", "board_certification_merchant_ach")
      client.board_merchant_ach(request_payload)
    end

    describe 'response on success' do
      let(:client) {
        Geti::AppClient.new(test_app_credentials, {}).tap{|c|
          mock_soap!(c, response, "BoardCertificationMerchant_ACH", "board_certification_merchant_ach")
        }
      }
      subject { client.board_merchant_ach(request_payload) }

      describe 'on success' do
        let(:response) { success_response }
        its([:status]) { should eq("Approved") }
      end

      describe 'on repeat' do
        let(:response) { repeat_response }
        its([:status]) { should eq("Pending") }
      end

      describe 'on error' do
        let(:response) { error_response }
        its([:status]) { should be_nil }
      end
    end
  end
end
