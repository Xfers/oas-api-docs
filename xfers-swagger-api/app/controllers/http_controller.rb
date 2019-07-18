require 'net/http'
require 'pp'

class HttpController < ApplicationController
  def initialize(url)
    @url = url
  end

  def make_request
    response = Net::HTTP.get_response URI(@url)
    response = JSON.parse(response.body)
  end
end
