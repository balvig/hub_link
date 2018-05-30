module Mergometer
  module Reports
    def self.contribution_report(repos)
      Reports::ContributionReport.new(PullRequests.last_week(repos).prs, show_average: false, show_total: false)
    end

    def self.individual_review_report(repos)
      Reports::IndividualReviewReport.new(PullRequests.last_week(repos).prs, load_reviews: true, show_average: false, show_total: false)
    end

    def self.pr_trend_report(repos)
      Reports::PrTrendReport.new(PullRequests.last_week(repos).prs, load_review: true, show_average: false, show_total: false)
    end

    def self.ranking_report(repos)
      Reports::RankingReport.new(PullRequests.last_week(repos).prs, load_review: true, show_average: false, show_total: false)
    end

    def self.review_required_report(repos)
      Reports::ReviewRequiredReport.new(PullRequests.last_week(repos).prs, load_reviews: true, show_average: false, show_total: false)
    end

    def self.weekly_report(repos)
      Reports::TimelyReport.new(PullRequests.last_week(repos).prs, show_average: false, show_total: false)
    end

    def self.save_all_to_csv(repos)
      all(repos).each(&:save_to_csv)
      puts "Saved all reports to csv"
    end

    def self.print_all_reports(repos)
      all(repos).each(&:print_report)
      puts "Printed all reports"
    end

    def self.save_all_graphs(repos)
      all(repos).each(&:save_graph)
      puts "Saved all graphs as PNG"
    end

    def self.all(repos)
      public_methods.select { |c| c.to_s.end_with?("_report") }.map do |method|
        public_send(method, repos)
      end
    end
  end
end
