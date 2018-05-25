require "mergometer"

begin
  report_type = Object.const_get("Mergometer::Reports::#{ARGV[1]}")
rescue NameError
  reports = Mergometer::Reports.constants.select { |c| c.to_s.end_with?("Report") }
  puts "Report not found, must be one of: \n\n" + reports.join("\n")
  exit
end
report_type.new(ARGV[0], from: ARGV[2]).run
