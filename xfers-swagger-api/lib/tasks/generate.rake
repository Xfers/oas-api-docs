directory '/Users/tandeningklement/Desktop/Parser/xfers-swagger-api/app/controllers'

desc "generate oas"
task :generate => :environment do
  master_oas_path = "../oas-doc-portal/src/oas_spec/master-openapi.json"
  oas_config_path = File.expand_path("config") + "/oas.yml"
  GenerateController.new(File.read(master_oas_path),YAML.load(File.read(oas_config_path)).generate
end
