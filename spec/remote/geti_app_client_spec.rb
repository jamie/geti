require 'helper'

describe Geti::AppClient do
  describe '#board_merchant_ach' do
    it 'has a successful response' do
      client = Geti::AppClient.new(test_app_credentials, {})
      response = client.board_merchant_ach({
        :id => 123456
      })
      response[:response][:status].must_equal "Pending"
      response[:response][:message].must_match /CrossRef: 123456/
    end
  end
end