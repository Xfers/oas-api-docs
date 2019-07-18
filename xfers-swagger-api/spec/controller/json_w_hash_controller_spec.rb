require 'rails_helper'

RSpec.describe JsonWHashController do
  describe "json to nested hash" do

    it "happy flow getting keys" do
      json = JSON.parse(file_fixture("sample_master_oas.json").read)
      json = json["paths"]
      expect(JsonWHashController.new(json).get_arr_keys).to eq json.keys
    end

    it "happy flow spliting keys to 2D array according to /" do
      json = JSON.parse(file_fixture("sample_master_oas.json").read)
      json = json["paths"]

      expected_arr = json.keys.map{|string|
        string.split("/").drop(1)
      }

      expect(JsonWHashController.new(json).split_keys_arr).to eq expected_arr
    end

    it "happy flow building structure of nested_hash" do
      json = JSON.parse(file_fixture("sample_master_oas.json").read)
      json = json["paths"]

      expected_structure = {"pet"=>{"findByStatus"=>{}, "findByTags"=>{}, "{petId}"=>{"uploadImage"=>{}}}, "store"=>{"inventory"=>{}, "order"=>{"{orderId}"=>{}}}, "user"=>{"createWithArray"=>{}, "createWithList"=>{}, "login"=>{}, "logout"=>{}, "{username}"=>{}}}
      split_keys = JsonWHashController.new(json).split_keys_arr

      expect(JsonWHashController.new(json).build_nested_hash(split_keys).get_nested_hash).to eq expected_structure
    end

    it "sad flow building structure of nested_hash" do
      json = JSON.parse(file_fixture("sample_master_oas.json").read)
      json = json["paths"]

      expected_structure = {"pet"=>{"findByStatus"=>{}, "findByTags"=>{}, "{petId}"=>{"uploadImage"=>{}}}, "store"=>{"inventory"=>{}, "order"=>{"{orderId}"=>{}}}, "user"=>{"createWithArray"=>{}, "createWithList"=>{}, "login"=>{}, "logout"=>{}, "{username}"=>{}}}
      split_keys = JsonWHashController.new(json).split_keys_arr

      expect(JsonWHashController.new(json).build_nested_hash(split_keys).build_nested_hash(split_keys)).to eq "Cannot call method twice"
    end

    it "happy flow for populating nested_hash" do
      json = JSON.parse(file_fixture("sample_master_oas.json").read)
      json = json["paths"]

      split_keys = JsonWHashController.new(json).split_keys_arr
      expected_populated_hash = JSON.parse(file_fixture("sample_populated_nested_hash.json").read)

      expect(JsonWHashController.new(json).build_nested_hash(split_keys).populate_nested_hash.get_nested_hash).to eq expected_populated_hash
    end

  end
end
