# frozen_string_literal: true

namespace :airtable do
  desc "Fetch from airtable"
  task :rest => :environment do
    puts "Fetching from airtable"

    File.atomic_write('data/copy.json') do |file|
      connection = AirtableClient.new().copy_records
      file.write(connection.to_json)
    end
  end
end
