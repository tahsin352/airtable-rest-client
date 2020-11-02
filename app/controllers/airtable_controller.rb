# Public: Airtable Controller
# All methods are controller methods and should be called on the airtable controller.
class AirtableController < ApplicationController
  # Public: Airtable API host
  AIRTABLE_API_HOST = "https://api.airtable.com".freeze

  # Public: Copy list records
  #
  # since - timestamp
  #
  # Returns json data.
  def index
    if request.query_parameters[:since].present?
      copy_records_file = JSON.parse(copy_records)
      copy_records_api = JSON.parse(copy_api_records)
      @updated = []
      record_str = copy_records_api["records"].map do |records, i|
        found = false
        copy_records_file["records"].map do |file|
          if records["id"] == file["id"]
            found = true
            @updated << records if (records["fields"]["Key"] != file["fields"]["Key"]) || (records["fields"]["Copy"] != file["fields"]["Copy"])
            break
          end
        end
        @updated << records unless found
      end
      render json: {:records => @updated }.to_json
    else
      render json: copy_records
    end
  end

  # Public: Copy details
  #
  # created_at - time
  # updated_at - time
  #
  # Returns json data.
  def show
    copy_records_parsed = JSON.parse(copy_records)
    record_str = copy_records_parsed["records"].map {|records| records["fields"]["Copy"] if records["fields"]["Key"].gsub(/\"/, '') == params[:key]}.compact.first
    if request.query_parameters[:created_at].present?
      time = Time.at(request.query_parameters[:created_at].to_i)
      created_at = time.strftime("%a %b %-d %l:%M:%S%p")
      result = {:value => record_str.tr('"', '').gsub!("{created_at, datetime}", created_at.to_s)}
    elsif request.query_parameters[:updated_at].present?
      time = Time.at(request.query_parameters[:updated_at].to_i)
      updated_at = time.strftime("%a %b %-d %l:%M:%S%p")
      result = {:value => record_str.tr('"', '').gsub!("{updated_at, datetime}", updated_at.to_s)}
    elsif request.query_parameters[:name].present? && request.query_parameters[:app].present?
      result = {:value => record_str.tr('"', '').gsub!("{name}", request.query_parameters[:name].to_s).gsub!("{app}", request.query_parameters[:app].to_s)}
    else
      result = {:value => record_str.tr('"', '')}
    end
    render json: result.to_json
	end

  # Public: Copy refresh
  #
  # Returns json data.
  def refresh
    File.atomic_write('data/copy.json') do |file|
      file.write(copy_api_records)
    end
    render json: copy_api_records
  end

  private

  # Private: Connection
  #
  # Returns connection with Airtable client
  def connection
    @connection ||= AirtableClient.new()
  end

  # Private: Copy base api records
  #
  # Returns copy base api records
  def copy_api_records
    connection.copy_records.to_json
  end

  # Private: Copy base file records
  #
  # Returns copy base file records
  def copy_records
    File.read("data/copy.json")
  end
end
