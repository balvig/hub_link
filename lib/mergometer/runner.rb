module Mergometer
  class Runner
    def initialize(report_name:, repo_name:)
      @report_name = report_name
      @repo_name = repo_name
    end

    def run
      report.new(repo_name).run
    end

    private
      def report_name
        @report_name.presence || stop
      end

      def repo_name
        @repo_name.presence || stop
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
        puts "\nUsage: OCTOKIT_ACCESS_TOKEN=<token> bin/run <report_name> <github_org/repo_name>"
        puts "\nAvailable reports: \n\n" + available_reports.join("\n")
        exit
      end

      def available_reports
        Mergometer::Reports.constants.select { |c| c.to_s.end_with?("Report") }
      end
  end
end
