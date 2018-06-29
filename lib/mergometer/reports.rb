module Mergometer
  module Reports
    def self.contribution_report(repos, **options)
      Reports::ContributionReport.new(repos, **options)
    end

    def self.individual_review_report(repos, **options)
      Reports::IndividualReviewReport.new(repos, **options)
    end

    def self.pr_trend_report(repos, **options)
      Reports::PrTrendReport.new(repos, **options)
    end

    def self.ranking_report(repos, **options)
      Reports::RankingReport.new(repos, **options)
    end

    def self.weekly_report(repos, **options)
      Reports::TimelyReport.new(repos, **options)
    end

    def self.save_all_to_csv(repos, **options)
      all(repos, **options).each(&:save_to_csv)
      puts "Saved all reports to csv"
    end

    def self.print_all_reports(repos, **options)
      all(repos, **options).each(&:print_report)
      puts "Printed all reports"
    end

    def self.save_all_graphs(repos, **options)
      all(repos, **options).each(&:save_graph)
      puts "Saved all graphs as PNG"
    end

    def self.all(repos, **options)
      public_methods.select { |c| c.to_s.end_with?("_report") }.map do |method|
        public_send(method, repos, **options)
      end
    end
  end
end
