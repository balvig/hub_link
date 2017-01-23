module Mergometer
  class Report
    require "hirb"

    ITEMS_PER_PAGE = 100
    PAGES = 10

    def initialize(repo, metric:)
      @repo = repo
      @metric = metric
    end

    def render
      puts "Metric: #{metric}"
      puts Hirb::Helpers::AutoTable.render(
        rankings,
        unicode: true,
        fields: fields,
        headers: headers,
        description: false
      )

      puts "Total number of PRs checked: #{prs.size}"
    end

    private

      attr_accessor :repo, :metric

      def fields
        headers.keys + [metric]
      end

      def headers
        {
          user: "Name",
          counts: "PR counts"
        }
      end

      def prs
        @_prs ||= items.map { |item| PullRequest.new(item) }
      end

      def prs_grouped_by_user
        prs.group_by(&:user)
      end

      def rankings
        @_rankings ||= sorted_rankings
      end

      def sorted_rankings
        eligible_rankings.sort_by do |ranking|
          [ranking.send(metric), -ranking.eligible_pr_count]
        end
      end

      def eligible_rankings
        build_rankings.reject(&:inactive?)
      end

      def build_rankings
        @_build_rankings ||= prs.group_by(&:user).map { |user, user_prs| Ranking.new(user, prs: user_prs) }
      end

      def items
        response = fetch_first_page
        PAGES.times do
          response.concat fetch_next_page
        end
        response
      end

      def fetch_first_page
        Octokit.search_issues("base:master repo:#{repo} type:pr is:merged", per_page: ITEMS_PER_PAGE).items
      end

      def fetch_next_page
        if next_page
          @last_response = next_page.get
          @last_response.data.items
        else
          puts "Did not find next page"
          []
        end
      end

      def next_page
        last_response.rels[:next]
      end

      def last_response
        @last_response || Octokit.last_response
      end
  end
end
