module Mergometer
  module Reports
    def self.contribution_report(repos)
      Reports::ContributionReport.new(PullRequests.last_week(repos).prs)
    end

    def self.individual_review_report(repos)
      Reports::IndividualReviewReport.new(PullRequests.last_week(repos).prs, load_reviews: true)
    end

    def self.pr_trend_report(repos)
      Reports::PrTrendReport.new(PullRequests.last_week(repos).prs, load_review: true)
    end

    def self.ranking_report(repos)
      Reports::RankingReport.new(PullRequests.last_week(repos).prs, load_review: true)
    end

    def self.review_report(repos)
      Reports::ReviewReport.new(PullRequests.last_week(repos).prs, load_reviews: true)
    end

    def self.weekly_report(repos)
      Reports::TimelyReport.new(PullRequests.last_week(repos).prs)
    end

    def self.save_all_to_csv(repos)
      all(repos).each(&:save_to_csv)
    end

    def self.print_all_reports(repos)
      all(repos).each(&:print_report)
    end

    def self.save_all_graphs(repos)
      all(repos).each(&:save_graph)
    end

    def self.all(repos)
      public_methods.select { |c| c.to_s.end_with?("_report") }.map do |method|
        public_send(method, repos)
      end
    end
  end
end
