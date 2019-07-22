class JsonWYamlController < JsonController
  def initialize(yml, master_oas_wo_paths_json, populate_nested_hash, curr_oas = {})
    @yml = yml
    @master_oas_wo_paths_json = master_oas_wo_paths_json
    @populate_nested_hash = populate_nested_hash
    @curr_oas = curr_oas
  end

  def generate_file_curr_json(name)
    path = File.expand_path("../oas-doc-portal/src/oas_spec") + "/" + name.to_s + ".json"
    file = File.open(path, "w")
    file.puts(JSON.pretty_generate(@curr_oas))
    file.close
    path = File.expand_path("template_oas") + "/" + name.to_s + ".json"
    file = File.open(path, "w")
    file.puts(JSON.pretty_generate(@curr_oas))
    file.close
  end

  def generate_doc(name)
    generate_curr_paths(@yml[name.to_sym]).process_for_tag(name).generate_file_curr_json(name)
  end

  def generate_all
    names_arr = @yml.keys
    names_arr.each do |curr_name|
      JsonWYamlController.new(@yml,@master_oas_wo_paths_json,@populate_nested_hash).generate_doc(curr_name)
    end
  end

   def process_for_tag(name)
    tags = @yml[name][:tags]
    tags_json = @curr_oas["tags"]
    curr_tags_json = tags_json.dup
    curr_tags_json.delete_if { |key, value|
      !tags.include? key["name"]
    }
    @curr_oas["tags"] = curr_tags_json
    JsonWYamlController.new(@yml, @master_oas_wo_paths_json, @populate_nested_hash, @curr_oas)
  end

  def process_for_params(name)
    paths_json = Hash[@curr_oas["paths"]]
    paths_json.each { |endpoint,outer_value|
      outer_value.each { |method, inner_value|
        next if inner_value["parameters"] == nil
        inner_value["parameters"].each { |curr_param|
          #byebug if curr_param["name"] == "rw" && name = "Singapore"
          next if curr_param["description"] == nil
          curr_words = curr_param["description"].split(" ")
          next if curr_words[0] != "ONLY"
          next if curr_words[1].include?(name.to_s)

          inner_value["parameters"].delete(curr_param)
          puts("deleted " + curr_param["name"].to_s + " for " + name.to_s)
        }
        inner_value.delete("parameters") if inner_value["parameters"].empty?
      }
    }
    curr_oas = Hash[@curr_oas]
    curr_oas["paths"] = paths_json
    JsonWYamlController.new(@yml, @master_oas_wo_paths_json, @populate_nested_hash, curr_oas)
  end

  def get_names
    @yml.keys
  end

  def travel_curr_path (split_key ,hash)
    return hash if split_key.empty?
    node = split_key[0]
    split_key = split_key.drop(1)
    travel_curr_path(split_key, hash[node])
  end

  def get_curr_oas
    @curr_oas
  end

  def generate_curr_paths(curr_name_yaml) #return new obj
    paths_to_gen_arr = curr_name_yaml[:paths]
    curr_obj = self
    paths_to_gen_arr.each { |curr_path|

      if !curr_path.include?("*")
        curr_obj = self.merge_a_path(curr_path)
      else
        all_paths = @populate_nested_hash.get_arr_keys
        all_paths.each { |path|
          if path.include?(curr_path.delete("*"))
            curr_obj = self.merge_a_path(path)
          end
        }
      end
    }
    upper_half = @master_oas_wo_paths_json.slice("openapi", "servers", "info", "tags")
    lower_half = @master_oas_wo_paths_json.slice("externalDocs", "components")
    processed_oas = {}
    processed_oas.merge!(upper_half)
    processed_oas.merge!({"paths" => @curr_oas})
    processed_oas.merge!(lower_half)
    JsonWYamlController.new(@yml, @master_oas_wo_paths_json, @populate_nested_hash, processed_oas)
  end

  def merge_a_path(path) #assume no * and return new obj
    split_curr_path = path.split("/").drop(1)
    curr_path_json = travel_curr_path(split_curr_path, @populate_nested_hash.get_nested_hash)
    "Invlid path: " + path if curr_path_json.empty?
    curr_path_json.each {|key, value|
      if key.include?("/")
        @curr_oas.merge!({key=> value})
      end
    }
    JsonWYamlController.new(@yml, @master_oas_wo_paths_json, @populate_nested_hash, @curr_oas)
  end

end
