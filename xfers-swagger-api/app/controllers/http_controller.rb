require 'net/http'
require 'pp'

class HttpController < ApplicationController
  def initialize(url)
    @url = url
  end

  def make_request
    response = Net::HTTP.get_response URI(@url)
    raise StandardError, "Connect failure. Please check you entered the correct URL or internet connect."if response.code != "200"
    puts("Successfully retrieve OAS from SwaggerUI")
    response = JSON.parse(response.body)
  end
end
