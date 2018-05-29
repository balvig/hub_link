require "mergometer"

begin
  report_type = Object.const_get("Mergometer::Reports::#{ARGV[1]}")
rescue NameError
  reports = Mergometer::Reports.constants.select { |c| c.to_s.end_with?("Report") }
  puts "Report not found, must be one of: \n\n" + reports.join("\n")
  exit
end
if ARGV[2]
  report_type.new(Mergometer::PullRequests.search(ARGV[0], from: ARGV[2]).prs).print_report
else
  report_type.new(Mergometer::PullRequests.last_week(ARGV[0]).prs).print_report
end
