class ParserController < ApplicationController
  attr_reader :master_oas_json, :oas_config, :curr_oas

  def copy_obj(obj)
    Marshal.load(Marshal.dump(obj))
  end

  def initialize(master_oas_json, oas_config, curr_oas = {})
    @master_oas_json = copy_obj(master_oas_json)
    @oas_config = copy_obj(oas_config)
    @curr_oas = copy_obj(curr_oas)
  end

  def add_general_info
    general_info = copy_obj(master_oas_json)
    general_info.delete("paths")
    general_info_upper = copy_obj(general_info).slice("openapi", "servers", "info", "tags")
    general_info_lower = copy_obj(general_info).slice("externalDocs", "components")
    curr_oas_holder = general_info_upper.merge(@curr_oas).merge(general_info_lower)
    ParserController.new(@master_oas_json,@oas_config,curr_oas_holder)
  end

  #name is in Symbol type
  def add_paths(name)
    if !@curr_oas["paths"].nil?
      raise StandardError, "path already added"
    end
    curr_path_item_objs = {}
    specific_paths = get_specific_path_arr(name) #array of paths in string that the documents wants
    master_path_item_objs = @master_oas_json["paths"]
    specific_paths.each {|path|
      if master_path_item_objs[path].nil?
        raise StandardError, "Matser oas does not contain #{path} check if you enter the correct parameter in oas.config"
      else
        path_item_obj =  copy_obj({path => master_path_item_objs[path]})
        curr_path_item_objs.merge!(path_item_obj)
      end
    }
    curr_path_obj = Hash["paths",curr_path_item_objs]
    curr_oas_holder = copy_obj(@curr_oas).merge!(curr_path_obj)
    ParserController.new(@master_oas_json,@oas_config,curr_oas_holder)
  end














  ### Helpers methods that do not support method chaining. Meant for internal use.

  def get_doc_names
    names = @oas_config.keys
    raise StandardError, "Empty oas.config" if names.nil? || names.empty?
    names
  end

  #Name is symbol type
  def get_specific_path_arr(name)
    raise StandardError "name of document entered does not match oas.config" if @oas_config[name].nil?
    paths = @oas_config[name][:paths]
    raise StandardError "no paths for #{name}" if paths.nil? || paths.empty?
    paths
  end

end
