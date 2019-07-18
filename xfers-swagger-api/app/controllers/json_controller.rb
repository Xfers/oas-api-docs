class JsonController < ApplicationController

  def initialize(json)
    @json = json
  end

  def get_json
    @json
  end

end
