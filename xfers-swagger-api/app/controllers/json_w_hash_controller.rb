class JsonWHashController < JsonController

  def initialize (json, nested_hash = {})
    super(json)
    @nested_hash = nested_hash
  end

  def get_arr_keys
    @json.keys
  end

  def get_nested_hash
    @nested_hash
  end

  def split_keys_arr
    @split_keys_arr = get_arr_keys.map{ |key|
      split_arr = key.split("/")
      split_arr.drop(1)
    }
  end

  def build_nested_hash(split_keys_arr)
    return "Cannot call method twice" if !@nested_hash.empty?
    curr_obj = self
    split_keys_arr.each {|split_keys|

      curr_obj = build_nested_hash_onepath(split_keys, self.get_nested_hash)

    }
    curr_obj
  end

  def build_nested_hash_onepath(arr, nested_hash) #can call method on any JsonWHash obj
    def helper(arr,hash)
      return if arr.empty?
      curr_node = arr[0]
      arr = arr.drop(1)
      if hash.has_key?(curr_node)
        helper(arr, hash[curr_node])
      else
        hash.merge!({curr_node=> Hash[]})
        helper(arr, hash[curr_node])
      end
    end

    helper(arr, nested_hash)
    return JsonWHashController.new(@json, nested_hash)
  end

  def travel_nested_hash(split_key,hash) #not stateless will just point to correct position in the current nested_has
    return hash if split_key.empty?
    curr_node = split_key[0]
    split_key = split_key.drop(1)
    travel_nested_hash(split_key, hash[curr_node])
  end

  def populate_nested_hash
    return "build nested hash first before populating" if get_nested_hash.empty?
    return "json file must be the value of the key 'path'" if @json.has_key?("paths")
    curr_obj = self
    @json.each {|key,value|
      split_key = key.split("/")
      split_key = split_key.drop(1)
      travel_nested_hash(split_key,curr_obj.get_nested_hash).merge!({key=>value})
      curr_obj = JsonWHashController.new(@json, curr_obj.get_nested_hash)
    }
    curr_obj
  end

end
