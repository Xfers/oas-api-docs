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
    it "should support method chaining of add path and add general info" do
      doc_name1 = @yml.keys[0]
      oas = @parser_controller.add_paths(doc_name1).add_general_info
      expect(oas.curr_oas.include?("openapi")).to eq true
      expect(oas.curr_oas.include?("info")).to eq true
      expect(oas.curr_oas.include?("paths")).to eq true
    end
    it "proccess tag happy flow" do
      doc_name1 = @yml.keys[0]
      oas = @parser_controller.add_paths(doc_name1).add_general_info.process_tag
      tags = oas.curr_oas["tags"][0]
      expect(tags["name"]).to eq "pets"
    end

    it "process params happy flow" do
      doc_name = @yml.keys[1]
      oas = @parser_controller.add_paths(doc_name).process_params(doc_name)
      expect(oas.curr_oas["paths"]["/pets/{petId}"]["get"]["parameters"].nil?).to eq true
    end

    it "process requestBody happy flow" do
      complex_json = "{\r\n\t\"paths\": {\r\n\t\t\"\/user\": {\r\n\t\t\t\"put\": {\r\n\t\t\t\t\"requestBody\": {\r\n\t\t\t\t\t\"required\": true,\r\n\t\t\t\t\t\"content\": {\r\n\t\t\t\t\t\t\"application\/x-www-form-urlencoded\": {\r\n\t\t\t\t\t\t\t\"schema\": {\r\n\t\t\t\t\t\t\t\t\"x-custom-params-requirements\": {\r\n\t\t\t\t\t\t\t\t\t\"Indonesia\": [\"id_front_url\", \"selfie_2id_url\", \"full_name\", \"identity_no\", \"gender\", \"mother_maiden_name\", \"date_of_birth\", \"place_of_birth\", \"marital_status\", \"occupation\", \"city\", \"state\", \"postal_code\", \"address_line_1\"]\r\n\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\"properties\": {\r\n\t\t\t\t\t\t\t\t\t\"id_front_url\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"URL storing the front image of user identity card\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"selfie_2id_url\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"URL storing the selfie of user holding their id card\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"mother_maiden_name\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Required for Indo, Optional for SG. Name of Mother\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"first_name\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Account holder firstname\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"last_name\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Account holder lastname\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"email\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"User email\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"date_of_birth\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \" Date of birth for account holder in yyyy-mm-dd\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"gender\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Gender. Possible values: male \/ female\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"address_line_1\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Address line 1\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"address_line_2\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Address line 2\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"nationality\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Account holder nationality\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"postal_code\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Address postal code\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"identity_no\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Account holder national identity number or, KTP number of Indonesian.\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"country\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Account holder country of residence.\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"city\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Account holder city of residence.\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"annual_income\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"integer\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Annual income of user in the local currency (SGD\/IDR)\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"id_back_url\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"URL storing the back of the user id card\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"proof_of_address_url\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"URL storing the proof of address\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"meta_data\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Addtional data like Jumio info dump.\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"place_of_birth\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Account holder\u2019s birth place.\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"blood_type\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \" Account holder\u2019s blood type, without rhesus. Possible values: \u2018A\u2019, \u2018B\u2019, 'AB\u2019, or 'O\u2019\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"rt\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"x-custom-params\": [\"Indonesia\"],\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Only Indonesia. Account holder\u2019s RT according to his\/her KTP. Leading zero is optional.\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"rw\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"x-custom-params\": [\"Indonesia\"],\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Account holder\u2019s RW according to his\/her KTP. Leading zero is optional.\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"administrative_village\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"x-custom-params\": [\"Indonesia\"],\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Account holder\u2019s administrative_village address. In KTP, it is called Kelurahan or Desa.\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"state\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"x-custom-params\": [\"Indonesia\"],\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Account holder\u2019s state of residence. In KTP, it is called Provinsi.\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"district\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"x-custom-params\": [\"Indonesia\"],\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Only Indonesia. Account holder\u2019s district address. In KTP, it is called Kecamatan.\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"religion\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"x-custom-params\": [\"Indonesia\"],\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Only Indonesia. Account holder\u2019s religion according to his\/her KTP. Possible Values: 'Islam\u2019, 'Katholik\u2019, 'Kristen Protestan\u2019, 'Hindu\u2019, 'Budha\u2019, 'Kong Hu Cu\u2019, or 'Aliran Kepercayaan\u2019\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"marital_status\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Only Indonesia. Account holder\u2019s marital status according to his\/her KTP. Possible Values: 'Belum Kawin\u2019, 'Kawin\u2019, 'Janda\u2019, or 'Duda\u2019\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"occupation\": {\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"x-custom-params\": [\"Indonesia\"],\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"Only Indonesia. Account holder\u2019s occupation according to his\/her KTP.\"\r\n\t\t\t\t\t\t\t\t\t},\r\n\t\t\t\t\t\t\t\t\t\"callback_url\": {\r\n\t\t\t\t\t\t\t\t\t\t\"deprecated\": true,\r\n\t\t\t\t\t\t\t\t\t\t\"type\": \"string\",\r\n\t\t\t\t\t\t\t\t\t\t\"description\": \"***This parameter is going through deprecation. It is still supported but we suggest you use the dash board in  {{base-api-url}}\/merchant_settings\/callback_settings to submit your callback url.***\\r\\n\\r\\nURL to receive callback notifications on account verification changes. This parameter is still supported but is going through deprecation. We strongly advice you to use the dashboard to set callback_url instead.\"\r\n\t\t\t\t\t\t\t\t\t}\r\n\t\t\t\t\t\t\t\t}\r\n\t\t\t\t\t\t\t}\r\n\t\t\t\t\t\t}\r\n\t\t\t\t\t}\r\n\t\t\t\t}\r\n\t\t\t}\r\n\t\t}\r\n\t}\r\n}"
      #Only in testing purposes hard code in the curr_oas
      oas = ParserController.new(@json,@yml, JSON.parse(complex_json))
      oas_sg = oas.process_requestBody(:Singapore)
      oas_id = oas.process_requestBody(:Indonesia)
      sg_schema = oas_sg.curr_oas["paths"]["/user"]["put"]["requestBody"]["content"]["application/x-www-form-urlencoded"]["schema"]
      id_schema = oas_id.curr_oas["paths"]["/user"]["put"]["requestBody"]["content"]["application/x-www-form-urlencoded"]["schema"]
      expect(sg_schema["requird"].nil?).to eq true
      expect(id_schema["required"]).to eq (["id_front_url", "selfie_2id_url", "full_name", "identity_no", "gender", "mother_maiden_name", "date_of_birth", "place_of_birth", "marital_status", "occupation", "city", "state", "postal_code", "address_line_1"])
      expect(sg_schema["properties"].has_key?("rw")).to eq false
      expect(sg_schema["properties"].has_key?("rt")).to eq false
      expect(id_schema["properties"].has_key?("rw")).to eq true
      expect(id_schema["properties"].has_key?("rt")).to eq true
    end
  end
end
