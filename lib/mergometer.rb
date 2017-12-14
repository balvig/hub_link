require "facets/math"
require "octokit"

require "mergometer/version"
require "mergometer/configuration"

reports_path = File.expand_path("../mergometer/reports/**/*.rb", __FILE__)
Dir[reports_path].each { |f| require f }

module Mergometer
  Configuration.new(cache_time: 72 * 3600).apply

  begin
    report_type = Object.const_get("Mergometer::Reports::#{ARGV.first}")
  rescue NameError
    reports = Mergometer::Reports.constants.select { |c| c.to_s.end_with?("Report") }
    puts "Report not found, must be one of: \n\n" + reports.join("\n")
    exit
  end

  report_type.new("cookpad/global-web").run
end
