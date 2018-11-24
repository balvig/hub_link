require "mergometer"
require "mergometer/configuration"
require "mergometer/reports_generator"

module Mergometer
  class Cli
    def self.run(*args)
      new(*args).run
    end

    def initialize(argv)
      @argv = argv
    end

    def run
      apply_configuration
      generate_reports
    end

    private

      attr_reader :argv

      def apply_configuration
        Configuration.new(cache_time: 72 * 3600).apply
      end

      def generate_reports
        ReportsGenerator.new(repo_names).run
      end

      def repo_names
        argv[0].presence || stop
      end

      def stop
        puts "\nUsage: OCTOKIT_ACCESS_TOKEN=<token> #{$0} <github_org/repo_name>"
        exit
      end
  end
end
