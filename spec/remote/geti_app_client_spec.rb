require 'helper'

describe Geti::AppClient do
  describe '#board_merchant_ach' do
    it 'with an empty payload' do
      client = Geti::AppClient.new(test_app_credentials, {})
      response = client.board_merchant_ach({
        # empty
      })
      pp response
    end
  end
end