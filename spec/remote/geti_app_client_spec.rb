require 'helper'

describe Geti::AppClient do
  before :all do
    @timestamp = Time.now.to_i
  end

  def merchant_params(ts)
    { :id               => ts,
      :name             => "Cogsley's Cogs %d" % ts,
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

  describe '#board_merchant_ach' do
    it 'has a successful response' do
      client = Geti::AppClient.new(test_credentials)
      response = client.board_merchant_ach(merchant_params(@timestamp))
      expect(response[:status]).to eq("Approved")
      expect(response[:app_data][:merchant][:cross_ref_id]).to eq((@timestamp).to_s)
      expect(response[:message]).to match(/CrossRef: #{@timestamp}/)
    end
  end

  describe '#retrieve_merchant_status' do
    it 'returns data' do
      client = Geti::AppClient.new(test_credentials)
      response = client.board_merchant_ach(merchant_params(@timestamp+1))

      response = client.retrieve_merchant_status(response[:app_data][:merchant][:id])
      expect(response[:status]).to eq("Approved")
      expect(response[:app_data][:merchant][:cross_ref_id]).to eq((@timestamp+1).to_s)
      expect(response[:message]).to eq("Merchant Approved")
    end
  end

  describe '#upload_supporting_docs' do
    it 'returns data' do
      client = Geti::AppClient.new(test_credentials)
      response = client.board_merchant_ach(merchant_params(@timestamp+2))

      response = client.upload_supporting_docs(response[:app_data][:merchant][:id], File.read('./spec/remote/sample.pdf'))
      expect(response[:status]).to eq("Approved")
      expect(response[:message]).to match("Document uploaded successfuly")
    end
  end
end