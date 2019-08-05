require 'net/http'
require 'uri'

class SwaggerController < ApplicationController
  attr_accessor :uri
  #GET /swagger
  def get_oas
    @master_oas
  end

  #POSTs swagger
  def request_swagger
    response = Net::HTTP.get_response URI(@uri)
    @master_oas = JSON.parse(response.body)
  end

  def standard_oas_template
    standard_oas = Hash[@master_oas]
    standard_oas.delete("paths")
    standard_oas
  end

end
