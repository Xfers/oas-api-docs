require 'rails_helper'
require 'yaml'

RSpec.describe ParserController do
  context "parse oas.json and config.yml" do
    before(:each) do
      @json = file_fixture("sample_master_oas.json").read
      @json = JSON.parse(@json)
      @yml = YAML.load(file_fixture("sample_oas_config.yml").read)
      @parser_controller = ParserController.new(@json,@yml)
      expect(@parser_controller.master_oas_json).to eq @json
      expect(@parser_controller.oas_config).to eq @yml
      expect(@parser_controller.curr_oas).to eq({})
    end

    it "should copy the arguement and not change the original object arguement" do
      @parser_controller.master_oas_json.delete("paths")
      expect(@json.include?("paths")).to eq true
      @parser_controller.master_oas_json.delete(:Singapore)
      expect(@yml.include?(:Tian)).to eq true
    end

    it "should add general info to empty oas" do
      oas = @parser_controller.add_general_info
      expect(oas.curr_oas.include?("openapi")).to eq true
      expect(oas.curr_oas.include?("info")).to eq true
      expect(!oas.curr_oas.include?("paths")).to eq true
    end
    it "should add general info to oas with only path" do
      oas = ParserController.new(@json,@yml, Hash["paths", {}]).add_general_info
      expect(oas.curr_oas.include?("openapi")).to eq true
      expect(oas.curr_oas.include?("info")).to eq true
      expect(oas.curr_oas.include?("paths")).to eq true
    end

    it "should return the name of the different docuements" do
      expect(@parser_controller.get_doc_names).to eq @yml.keys
    end

    it "should return the specific paths for woth respect to a specific document" do
      expect(@parser_controller.get_specific_path_arr(@yml.keys[0])).to eq @yml[@yml.keys[0]][:paths]
    end
    it "should add paths according to oas.config" do
      doc_name1 = @yml.keys[0]
      doc_name2 = @yml.keys[1]
      oas1 = @parser_controller.add_paths(doc_name1)
      oas2 = @parser_controller.add_paths(doc_name2)
      expect(oas1.curr_oas["paths"].nil?).to eq false
      expect(oas1.curr_oas["paths"].keys).to eq @yml[doc_name1][:paths]
      expect(oas2.curr_oas["paths"].nil?).to eq false
      expect(oas2.curr_oas["paths"].keys).to eq @yml[doc_name2][:paths]
    end


  end
end
