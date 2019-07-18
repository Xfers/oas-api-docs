require 'json'

class ParserController < ApplicationController
  attr_accessor :master_oas

  def initialize
    @nested_hash = Hash[]
  end

  def build_structure(keys_arr)
    split_keys = keys_arr.map!{|x| x.split("/")}
    split_keys.map!{|x| x.drop(1)}
    split_keys.each do |curr_split_key|
      insert_hash(curr_split_key, @nested_hash)
    end
  end

  def insert_hash(arr, hash)
    return if arr.empty?
    curr_cat = arr[0]
    arr = arr.drop(1)
    if hash.has_key?(curr_cat)
      insert_hash(arr, hash[curr_cat])
    else
      hash.merge!({curr_cat=> Hash[]})
      insert_hash(arr, hash[curr_cat])
    end
  end

  def travel_tree (split_key ,hash)
    return hash if split_key.empty?
    cat = split_key[0]
    split_key = split_key.drop(1)
    travel_tree(split_key, hash[cat])
  end

  def process
    paths_hash = master_oas["paths"]
    build_structure(paths_hash.keys)
    byebug
    paths_hash.each {|key,value|
      split_key = key.split("/")
      split_key = split_key.drop(1)
      travel_tree(split_key,@nested_hash).merge!({key=>value})
    }
    byebug
    @nested_hash.to_json
  end
end
