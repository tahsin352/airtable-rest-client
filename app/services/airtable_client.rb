# frozen_string_literal: true

# Public: RestClient Service
# All methods are controller methods and should be called on the RestClient controller.
class AirtableClient
  AIRTABLE_API_HOST = "https://api.airtable.com".freeze

  # Public: Initialize AirtableClient
  def Initialize
  end

  # Public: Get copy base record list
  #
  # Returns json data.
  def copy_records
    connection(airtable_api_key).get("/v0/#{airtable_app_key}/Table%201")
  end

  private

  # Private: AirtableClient Connection
  #
  # access_token - access token
  #
  # Returns connection with RestClient
  def connection(access_token)
    @connection ||= RestClient.new(
      access_token: access_token,
      api_host: AIRTABLE_API_HOST
    )
  end

  # Private: airtable_api_key
  #
  # Returns configuration value of airtable_api_key
  def airtable_api_key
    Rails.application.config.airtable_api_key
  end

  # Private: airtable_app_key
  #
  # Returns configuration value of airtable_app_key
  def airtable_app_key
    Rails.application.config.airtable_app_key
  end
end