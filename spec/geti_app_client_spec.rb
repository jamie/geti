require 'spec_helper'
require 'savon/mock/spec_helper'

describe Geti::AppClient do
  include Savon::SpecHelper
  before(:all) { savon.mock! }
  after(:all)  { savon.unmock! }

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

  describe '#board_merchant_ach' do
    it 'calls BoardCertificationMerchant_ACH' do
      savon.expects(:board_certification_merchant_ach).with(:message => :any).returns(fixture(:board_certification_merchant_ach_pending))
      client = Geti::AppClient.new(test_credentials, {})
      client.board_merchant_ach(request_payload)
    end

    it 'calls BoardMerchant_ACH in production' do
      savon.expects(:board_merchant_ach).with(:message => :any).returns(fixture(:board_merchant_ach))
      client = Geti::AppClient.new(test_credentials, {}, 'production')
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
      before do
        savon.expects(:board_certification_merchant_ach).
          with(:message => :any).
          returns(response)
      end

      let(:client) { Geti::AppClient.new(test_credentials, {}) }
      subject { client.board_merchant_ach(request_payload) }

      describe 'on pending' do
        let(:response) { fixture(:board_certification_merchant_ach_pending) }
        its([:success]) { should be_true }
        its([:status]) { should eq("Pending") }

        it 'normalizes (nested) keys' do
          subject[:app_data][:merchant][:id].should eq("1844832")
        end
      end

      describe 'on success' do
        let(:response) { fixture(:board_certification_merchant_ach_approved) }
        its([:success]) { should be_true }
        its([:status]) { should eq("Approved") }

        it 'normalizes (nested) keys' do
          subject[:app_data][:merchant][:id].should eq("20")
        end
      end

      describe 'on repeat' do
        let(:response) { fixture(:board_certification_merchant_ach_repeat) }
        its([:success]) { should be_true }
        its([:status]) { should eq("Pending") }
      end

      describe 'on error' do
        let(:response) { fixture(:board_certification_merchant_ach_error) }
        its([:success]) { should be_false }
        its([:status]) { should be_nil }
      end
    end

    describe 'production response handling' do
      it 'does not error' do
        savon.expects(:board_merchant_ach).with(:message => :any).returns(fixture(:board_merchant_ach))
        client = Geti::AppClient.new(test_credentials, {}, 'production')

        response = client.board_merchant_ach(request_payload)
      end
    end
  end

  describe '#taxpayer_info' do
    let(:client) { Geti::AppClient.new(test_credentials, {}) }

    it 'includes taxpayer_name' do
      expect(client.taxpayer_info(request_payload)).to include("Tax Info: Carl Cogsley")
    end

    it 'includes taxpayer_id' do
      expect(client.taxpayer_info(request_payload)).to include("123456789")
    end

    it 'does not usually include SSN' do
      expect(client.taxpayer_info(request_payload)).not_to include("111222123")
    end

    it 'includes SSN for sole proprietorships' do
      payload = request_payload
      payload[:business_type] = "Sole Proprietorship"
      expect(client.taxpayer_info(payload)).to include("111222123")
    end

  end
end
