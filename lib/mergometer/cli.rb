require "mergometer"

module Mergometer
  class Cli
    def self.run(*args)
      new(*args).run
    end

    def initialize(argv)
      @argv = argv
    end

    def run
      report.new(repo_names, from: from).print_report
    end

    private

      attr_reader :argv

      def report_name
        argv[1].presence || stop
      end

      def repo_names
        argv[0].presence || stop
      end

      def from
        argv[2].presence
      end

      def report
        Object.const_get(report_class_name)
      rescue NameError
        stop
      end

      def report_class_name
        "Mergometer::Reports.#{report_name}"
      end

      def stop
        puts "\nUsage: OCTOKIT_ACCESS_TOKEN=<token> #{$0} <comma_separated_github_org/repo_names> <report_name> <from>"
        puts "\nAvailable reports: \n\n" + available_reports.join("\n")
        exit
      end

      def available_reports
        Mergometer::Reports.public_methods.select { |c| c.to_s.end_with?("_report") }
      end
  end
end
