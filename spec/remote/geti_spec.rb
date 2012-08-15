require 'helper'

describe Geti::Client do
  describe 'get_certification_terminal_settings' do
    it 'gets a success response' do
      client = Geti::Client.new()
      response = client.get_certification_terminal_settings()
      response['terminal_id'].must_equal 2310
    end
  end
end
