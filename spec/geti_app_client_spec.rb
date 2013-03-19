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

      :ip => '127.0.0.1',
      :email => 'bob@example.com'
    }
  end

  def production_soap_response
    Nori.parse("<?xml version=\"1.0\" encoding=\"utf-8\"?><soap:Envelope xmlns:soap=\"http://schemas.xmlsoap.org/soap/envelope/\" xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"><soap:Body><BoardMerchant_ACHResponse xmlns=\"http://tempuri.org/GETI.eMagnus.WebServices/AppGateway\"><BoardMerchant_ACHResult>&lt;?xml version=\"1.0\" encoding=\"utf-8\"?&gt;&lt;RESPONSE xmlns:xsi=\"http://www.w3.org/2001/XMLSchema-instance\" xmlns:xsd=\"http://www.w3.org/2001/XMLSchema\"&gt;&lt;STATUS&gt;Pending&lt;/STATUS&gt;&lt;MESSAGE&gt;1 merchant(s) created.\n0 merchant(s) not created due to errors.\n\n-----------------------\nMerchants Created:\nMy Company (ISO ID: 10150, CrossRef: 83, Status: PendingInput)\n\n&lt;/MESSAGE&gt;&lt;APP_DATA&gt;&lt;Merchant ID=\"1844832\" /&gt;&lt;/APP_DATA&gt;&lt;VALIDATION_MESSAGE&gt;&lt;RESULT&gt;Passed&lt;/RESULT&gt;&lt;SCHEMA_FILE_PATH /&gt;&lt;/VALIDATION_MESSAGE&gt;&lt;/RESPONSE&gt;</BoardMerchant_ACHResult></BoardMerchant_ACHResponse></soap:Body></soap:Envelope>\n")[:envelope][:body]
  end

  def pending_response
    {:response=>
      {:status=>"Pending",
       :"@xmlns:xsd"=>"http://www.w3.org/2001/XMLSchema",
       :"@xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
       :message=>
        "1 merchant(s) created.\n0 merchant(s) not created due to errors.\n\n-----------------------\nMerchants Created:\nMy Company (ISO ID: 10150, CrossRef: 83, Status: PendingInput)\n\n",
       :validation_message=>{:schema_file_path=>nil, :result=>"Passed"},
       :app_data=>{:merchant=>{:@id=>"1844832"}}}}
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
      client = Geti::AppClient.new(test_credentials, {})
      mock_soap!(client, pending_response, "BoardCertificationMerchant_ACH", "board_certification_merchant_ach")
      client.board_merchant_ach(request_payload)
    end

    it 'calls BoardMerchant_ACH in production' do
      client = Geti::AppClient.new(test_credentials, {}, 'production')
      mock_soap!(client, pending_response, "BoardMerchant_ACH", "board_merchant_ach")
      client.board_merchant_ach(request_payload)
    end

    describe 'comments field' do
      before do
        client = Geti::AppClient.new(test_credentials, {})
        @full_xml = client.data(Builder::XmlMarkup.new, request_payload)

        client = Geti::AppClient.new(test_credentials, {})
        payload = request_payload.dup
        payload.delete(:ip)
        payload.delete(:email)
        @sparse_xml = client.data(Builder::XmlMarkup.new, payload)
      end

      it 'fills with taxpayer info' do
        @full_xml =~ /merchComments="([^"]+)"/
        $1.should match("Tax Info: Carl Cogsley - 123456789")

        @sparse_xml =~ /merchComments="([^"]+)"/
        $1.should match("Tax Info: Carl Cogsley - 123456789")
      end

      it 'fills with signup IP' do
        @full_xml =~ /merchComments="([^"]+)"/
        $1.should match("Signup IP: 127.0.0.1")

        @sparse_xml =~ /merchComments="([^"]+)"/
        $1.should_not match("IP")
      end

      it 'fills with signup email' do
        @full_xml =~ /merchComments="([^"]+)"/
        $1.should match("Email: bob@example.com")

        @sparse_xml =~ /merchComments="([^"]+)"/
        $1.should_not match("Email")
      end
    end

    describe 'character filtering' do
      let(:client) { Geti::AppClient.new(test_credentials, {}) }

      it 'filters city' do
        data = request_payload.merge(:city => 'St. Johns')
        client.filter_invalid_characters(data)[:city].should == "St Johns"
      end

      it 'filters address' do
        data = request_payload.merge(:address => '12 Main St, Suite B!')
        client.filter_invalid_characters(data)[:address].should == "12 Main St, Suite B"
      end

      it 'filters physical_city' do
        data = request_payload.merge(:physical_city => 'St. Johns')
        client.filter_invalid_characters(data)[:physical_city].should == "St Johns"
      end

      it 'filters physical_address' do
        data = request_payload.merge(:physical_address => '12 Main St, Suite B!')
        client.filter_invalid_characters(data)[:physical_address].should == "12 Main St, Suite B"
      end

      it 'filters principal_city' do
        data = request_payload.merge(:principal_city => 'St. Johns')
        client.filter_invalid_characters(data)[:principal_city].should == "St Johns"
      end

      it 'filters principal_address' do
        data = request_payload.merge(:principal_address => '12 Main St, Suite B!')
        client.filter_invalid_characters(data)[:principal_address].should == "12 Main St, Suite B"
      end

      it 'filters principal_ssn' do
        data = request_payload.merge(:principal_ssn => '111-22-3333')
        client.filter_invalid_characters(data)[:principal_ssn].should == "111223333"
      end

    end

    describe 'response on success' do
      let(:client) {
        Geti::AppClient.new(test_credentials, {}).tap{|c|
          mock_soap!(c, response, "BoardCertificationMerchant_ACH", "board_certification_merchant_ach")
        }
      }
      subject { client.board_merchant_ach(request_payload) }

      describe 'on pending' do
        let(:response) { pending_response }
        its([:success]) { should be_true }
        its([:status]) { should eq("Pending") }

        it 'normalizes (nested) keys' do
          subject[:app_data][:merchant][:id].should eq("1844832")
        end
      end

      describe 'on success' do
        let(:response) { success_response }
        its([:success]) { should be_true }
        its([:status]) { should eq("Approved") }

        it 'normalizes (nested) keys' do
          subject[:app_data][:merchant][:id].should eq("20")
        end
      end

      describe 'on repeat' do
        let(:response) { repeat_response }
        its([:success]) { should be_true }
        its([:status]) { should eq("Pending") }
      end

      describe 'on error' do
        let(:response) { error_response }
        its([:success]) { should be_false }
        its([:status]) { should be_nil }
      end
    end

    describe 'production response handling' do
      it 'does not error' do
        client = Geti::AppClient.new(test_credentials, {}, 'production').tap{|c|
          c.soap_client.should_receive(:request).with("BoardMerchant_ACH").and_return(OpenStruct.new(:body => production_soap_response))
        }

        response = client.board_merchant_ach(request_payload)
      end
    end
  end
end
