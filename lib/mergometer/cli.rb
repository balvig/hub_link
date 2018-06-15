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
      report.new(repo_name).run
    end

    private

      attr_reader :argv

      def report_name
        argv[0].presence || stop
      end

      def repo_name
        argv[1].presence || stop
      end

      def report
        Object.const_get(report_class_name)
      rescue NameError
        stop
      end

      def report_class_name
        "Mergometer::Reports::#{report_name}"
      end

      def stop
        puts "\nUsage: OCTOKIT_ACCESS_TOKEN=<token> #{$0} <report_name> <github_org/repo_name>"
        puts "\nAvailable reports: \n\n" + available_reports.join("\n")
        exit
      end

      def available_reports
        Mergometer::Reports.constants.select { |c| c.to_s.end_with?("Report") }
      end
  end
end
