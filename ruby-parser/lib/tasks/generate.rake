controller_absolute_path = File.expand_path("app/controllers")
directory controller_absolute_path

desc "generate oas"
task :generate => :environment do
  master_oas_path = "../react-page/src/oas_spec/master-openapi.json"
  oas_config_path = File.expand_path("config") + "/oas.yml"
  MainController.new(File.read(master_oas_path),YAML.load(File.read(oas_config_path))).generate
end
