# frozen_string_literal: true

# Public: RestClient Service
# All methods are controller methods and should be called on the RestClient controller.
class RestClient
  # Public: Initialize the RestClient class.
  #
  # access_token - access token
  # api_host - api host
  def initialize(access_token:, api_host:)
    @access_token = access_token
    @api_host = api_host
  end

  # Public: Get request
  #
  # url - request URL
  #
  # Returns json data.
  def get(url)
    call(url: url)
  end

  # Public: Post request
  #
  # url - request URL
  # body - body content
  #
  # Returns json data.
  def post(url, body = {})
    call(url: url, action: :post, body: body)
  end

  # Public: Put request
  #
  # url - request URL
  # body - body content
  #
  # Returns json data.
  def put(url, body = {})
    call(url: url, action: :put, body: body)
  end

  # Public: Delete request
  #
  # url - request URL
  #
  # Returns json data.
  def delete(url)
    call(url: url, action: :delete)
  end

  # Public: Call request
  #
  # url - request URL
  # action - method
  #
  # Returns json data.
  def call(url:, action: :get, **options)
    response = client.send(action, url, options[:body], 'Content-Type': 'application/json')

    unless response.success?
      Rails.logger.info("#API response fail: #{response.inspect}")
      raise ::Errors::BadRequest
    end

    return JSON.parse response.body if response.status == 200
  end

  # Public: Call request
  #
  # url - request URL
  #
  # Returns downloaded data.
  def download(url)
    response = client.send(:get, url, {}, 'Content-Type': 'text/html')
    raise ::Errors::BadRequest unless response.success?

    response.body
  end

  private

  # Private: access_token, api_host
  attr_reader :access_token, :api_host

  # Public: Client connection
  #
  # Returns connection object
  def client
    @client ||= Faraday.new(api_host) do |faraday|
      faraday.headers["Authorization"] = "Bearer #{access_token}"
      faraday.response :logger if Rails.env.test?
      faraday.adapter Faraday.default_adapter
    end
  end
end
