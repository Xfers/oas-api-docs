class YamlController < ApplicationController

  def initialize(yml ,standard_oas_template, master_oas_processed)
    @yml = yml
    @standard_oas_template = standard_oas_template
    @master_oas_processed = master_oas_processed
  end

  def get_path_json (split_key ,hash)
    return hash if split_key.empty?
    cat = split_key[0]
    split_key = split_key.drop(1)
    get_path_json(split_key, hash[cat])
  end

  def process_for_path(json)
    paths_json = {}
    paths_arr = json[:paths]
    paths_arr.each do |x|
      split_curr_path = x.split("/").drop(1)
      curr_path_json = get_path_json(split_curr_path, @master_oas_processed)
      byebug if curr_path_json == nil
      curr_path_json.each {|key, value|
        if key.include?("/")
          paths_json.merge!({key=> value})
        end
      }
    end
    upper_half = @standard_oas_template.slice("openapi", "servers", "info", "tags")
    lower_half = @standard_oas_template.slice("externalDocs", "components")
    processed_oas = {}
    processed_oas.merge!(upper_half)
    processed_oas.merge!({"paths" => paths_json})
    processed_oas.merge!(lower_half)
    processed_oas
  end

  def process_for_tag(name, json)
    tags = @yml[name][:tags]
    tags_json = json["tags"]
    tags_json.delete_if { |key, value|
      !tags.include? key["name"]
    }
  end

  def process_for_params(name, json)
    paths_json = json["paths"]
    paths_json.each { |endpoint,outer_value|
      outer_value.each { |method, inner_value|
        next if inner_value["parameters"] == nil
        inner_value["parameters"].each { |curr_param|
          curr_words = curr_param["description"].split(" ")
          next if curr_words[0] != "ONLY"
          next if curr_words == name
          inner_value["parameters"].delete(curr_param)
        }
        inner_value.delete("parameters") if inner_value["parameters"].empty?
      }
    }
  end


  def process
    doc_name = @yml.keys
    doc_name.each do |x|
      curr_oas = process_for_path(@yml[x])
      process_for_tag(x, curr_oas)
      process_for_params(x, curr_oas)
      path = File.expand_path("template_oas") + "/" + x.to_s + ".json"
      file = File.open(path, "w")
      file.puts(JSON.pretty_generate(curr_oas))
      file.close
    end
  end
end
