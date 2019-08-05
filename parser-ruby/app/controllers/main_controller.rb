class MainController < ApplicationController
  attr_reader :master_oas_json


  def initialize(master_oas_json, oas_config)
    @master_oas_json = copy_obj(JSON.parse(master_oas_json))
    @oas_config = copy_obj(oas_config)
    if @master_oas_json.is_a?(Hash) || @oas_config.is_a?(Hash)
      puts("successfully loaded file")
    else
      raise StandardError, "Path to file must be json for OAS and yaml for Config"
    end
  end

  def copy_obj(obj)
    Marshal.load(Marshal.dump(obj))
  end

  def generate
    ParserController.new(@master_oas_json, @oas_config).generate_all
    puts("OAS docs generated")
  end

end

