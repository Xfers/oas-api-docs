require 'rails_helper'

RSpec.describe MainController do
  describe "The driver class of the whole parser" do
    before(:each) do
      @json = file_fixture("sample_master_oas.json").read
      @yml = YAML.load(file_fixture("sample_oas_config.yml").read)
      @main_controller = MainController.new(@json,@yml)
    end

    it "should successfully create a copy of the master_oas_json obj" do
      @main_controller.master_oas_json.delete("path")
      expect(@json.include?("path")).to eq true
    end
  end
end
