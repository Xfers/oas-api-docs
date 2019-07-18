require 'rails_helper'
require 'yaml'

RSpec.describe JsonWYamlController do
  context "generate oas doc according to yaml" do

    before(:each) do
      yaml_path = File.expand_path("spec/fixtures/files") + "/sample_oas.yml"
      @curr_yml = YAML.load(File.read(yaml_path))
      master_oas_wo_paths_json = JSON.parse(file_fixture("sample_master_oas.json").read)
      master_oas_wo_paths_json.delete("paths")
      populate_nested_hash = JSON.parse(file_fixture("sample_populated_nested_hash.json").read)
      @json_w_yml = JsonWYamlController.new(@curr_yml, master_oas_wo_paths_json, populate_nested_hash)
    end

    describe "test utility function" do

      it "should get array of names " do
        expect(@json_w_yml.get_names).to eq [:Singapore, :Indonesia]
      end

      it "should successfully merge one path" do
        path = "/pet/findByStatus"
        curr_path_json = {"/pet/findByStatus":{
         "get":{
            "tags":[
               "pet"
            ],
            "summary":"Finds Pets by status",
            "description":"Multiple status values can be provided with comma separated strings",
            "operationId":"findPetsByStatus",
            "parameters":[
               {
                  "name":"status",
                  "in":"query",
                  "description":"ONLY Indonesia Status values that need to be considered for filter",
                  "required":true,
                  "explode":true,
                  "schema":{
                     "type":"array",
                     "items":{
                        "type":"string",
                        "enum":[
                           "available",
                           "pending",
                           "sold"
                        ],
                        "default":"available"
                     }
                  }
               }
            ],
            "responses":{
               "200":{
                  "description":"successful operation",
                  "content":{
                     "application/json":{
                        "schema":{
                           "type":"array",
                           "items":{
                              "$ref":"#/components/schemas/Pet"
                           }
                        }
                     },
                     "application/xml":{
                        "schema":{
                           "type":"array",
                           "items":{
                              "$ref":"#/components/schemas/Pet"
                           }
                        }
                     }
                  }
               },
               "400":{
                  "description":"Invalid status value"
               }
            },
            "security":[
               {
                  "petstore_auth":[
                     "write:pets",
                     "read:pets"
                  ]
               }
            ]
         }
        }}
        expect(@json_w_yml.merge_a_path("/pet/findByStatus").get_curr_oas.to_json).to eq curr_path_json.to_json
      end

      it "should succssfully generate the api paths only for Singapore" do
        expected_singapore_oas = JSON.parse(file_fixture("sample_singapore_oas.json").read)
        expect(@json_w_yml.generate_curr_paths(@curr_yml[:Singapore]).get_curr_oas).to eq expected_singapore_oas
      end


    end
  end
end
