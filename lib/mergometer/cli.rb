require "mergometer"
require "optparse"

module Mergometer
  class Cli
    def self.run
      new.run
    end

    def initialize
      @argv = *ARGV
      @options = {}
      parse_options
    end

    def run
      report.print_report
    end

    private

      attr_reader :argv
      attr_accessor :options

      def report_name
        argv[1].presence || stop
      end

      def repo_names
        argv[0].presence || stop
      end

      def parse_options
        OptionParser.new do |opt|
          opt.on("-f", "--from FROM_DATE", "Date from which it will fetch PRs") { |o| options[:from] = o }
          opt.on("-u", "--user USERNAME", "Github username of user related to report (user_report)") { |o| options[:user] = o }
        end.parse!
      end

      def report
        if Mergometer::Reports.respond_to?(report_name)
          Mergometer::Reports.public_send(report_name, repo_names, **options)
        else
          stop
        end
      end

      def stop
        puts "\nUsage: OCTOKIT_ACCESS_TOKEN=<token> #{$0} <comma_separated_github_org/repo_names> <report_name> <options>"
        puts "\nAvailable reports: \n\n" + available_reports.join("\n")
        exit
      end

      def available_reports
        Mergometer::Reports.public_methods.select { |c| c.to_s.end_with?("_report") }
      end
  end
end
