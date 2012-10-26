$: << 'lib'
require 'rubygems'
require 'bundler/setup'
require 'geti'
require 'pp'


def merchant_params
  { :id               => 12345,
    :name             => "ACH Merchant Cert",
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

def test_credentials
  YAML.load(File.read('config/test_credentials.yml'))
end

client = Geti::AppClient.new(test_credentials)

# Step 2: Create and board a new ACH merchant named “ACH Merchant Cert”.  This merchant should have 1 Location and 1 Terminal.
# Step 3: Email GETI the Merchant ID received for “ACH Merchant Cert”.
#response = client.board_merchant_ach(merchant_params)
id = '26'

# Step 4: GETI will activate this merchant and email back when complete.
# Step 5: Run “Retrieve Merchant Status” with the Merchant ID you received for “ACH Merchant Cert ” and email GETI the Location ID and Terminal ID.
#response = client.retrieve_merchant_status(id)

# Step 6: Upload a pdf to “ACH Merchant Cert” (this would be a signed merchant application in production) and email GETI when complete.
#response = client.upload_supporting_docs(id, File.read('./spec/remote/sample.pdf'))

pp response
