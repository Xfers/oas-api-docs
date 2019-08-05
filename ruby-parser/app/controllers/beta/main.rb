require 'net/http'
require 'pp'

class Main< ApplicationController

  def run
    process_master_oas
    yaml_path = File.expand_path("config") + "/oas.yml"
    yaml_file = YAML.load(File.read(yaml_path))
    yaml = YamlController.new(yaml_file, @standard_oas_template, @master_oas_processed)
    yaml.process
    byebug
  end

  def write_file (name, json_file)
    path = File.expand_path("template_oas") + "/" + name +".json"
    file = File.open(path, "w")
    file.puts(json_file)
    file.close
  end

  def process_master_oas
    swagger = SwaggerController.new
    swagger.uri = "https://api.swaggerhub.com/apis/xfers/API2/1.0.0/swagger.json"
    swagger.request_swagger
    @master_oas = swagger.request_swagger
    @standard_oas_template = swagger.standard_oas_template
    write_file("master_oas", JSON.pretty_generate(@master_oas))
    parser = ParserController.new
    parser.master_oas = @master_oas
    @master_oas_processed = JSON.parse(parser.process)
    write_file("master_oas_processed", JSON.pretty_generate(@master_oas_processed))
  end

end
