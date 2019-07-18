require 'rails_helper'

RSpec.describe HttpController do
  describe "http request to swagger" do

    url = "https://api.swaggerhub.com/apis/xfers/API2/1.0.0/swagger.json"

    it "happy flow" do
      expect(HttpController.new(url).make_request[:code]).to eq nil
    end

    it "sad flow" do
      expect(HttpController.new(url+"123").make_request["code"]).to eq 404
    end

  end
end
