require 'rails_helper'

RSpec.describe JsonController do
  describe "instantiate obj with json" do
    it "happy flow" do
      json = file_fixture("sample_master_oas.json").read
      expect(JsonController.new(json).get_json).to eq json
    end
  end
end
