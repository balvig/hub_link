require "Date"

module Mergometer
  class PullRequests
    class << self
      def search(repos, **options)
        filter = query_from_options(options).map do |o|
          "#{repo_query(repos)} #{o}"
        end
        pull_requests = new(filter.pop)
        filter.each do |f|
          pull_requests.merge(new(f))
        end
        pull_requests
      end

      def this_week(repos, **options)
        options[:from] = Date.today.beginning_of_week.strftime("%F")
        options[:to] = Date.today.end_of_week.strftime("%F")
        search(repos, **options)
      end

      def last_week(repos, **options)
        options[:from] = Date.today.last_week.beginning_of_week.strftime("%F")
        options[:to] = Date.today.last_week.end_of_week.strftime("%F")
        search(repos, **options)
      end

      def this_month(repos, **options)
        options[:from] = Date.today.beginning_of_month.strftime("%F")
        options[:to] = Date.today.end_of_month.strftime("%F")
        search(repos, **options)
      end

      def last_month(repos, **options)
        options[:from] = Date.today.last_month.beginning_of_month.strftime("%F")
        options[:to] = Date.today.last_month.end_of_month.strftime("%F")
        search(repos, **options)
      end

      def query_from_options(options)
        options = {
          type: "pr",
          base: "master",
          **options
        }
        if options[:from]
          date_query_array(from: options[:from], to: options[:to]).map do |dq|
            "#{filtered_query(options)} #{dq}"
          end
        else
          filtered_query(options)
        end
      end

      def filtered_query(options)
        query = options[:query]
        options.tap do |hs|
          hs.delete(:from)
          hs.delete(:to)
          hs.delete(:query)
        end
        options.map { |k, v| "#{k}:#{v}" }.join(" ") + " #{query}"
      end

      def date_query_array(from:, to:)
        to = to || Date.today.to_s
        _, *dates = (Date.parse(from)..Date.parse(to)).group_by(&:beginning_of_month).map do |_, month|
          month.first
        end
        req_dates = [Date.parse(from), *dates]
        req_dates.each_with_index.map do |date, i|
          "created:#{date}..#{(req_dates[i + 1] || Date.parse(to) + 1) - 1}"
        end
      end

      def repo_query(repos)
        if repos.is_a?(String)
          repos.split(",")
        elsif repos.is_a?(Array) && repos.first&.is_a?(String)
          repos
        else
          raise "Invalid repo parameter"
        end.map do |r|
          "repo:#{r}"
        end.join(" ")
      end
    end

    attr_accessor :prs

    def initialize(filter)
      @prs = Octokit.search_issues(filter).items.map do |item|
        PullRequest.new(item)
      end
    end

    def merge(pull_requests)
      prs.push(*pull_requests.prs)
    end

    def review_required_prs
      prs.select(&:review_required)
    end

    def merged_prs
      prs.select(&:merged?)
    end

    def size
      count
    end

    def count
      prs.size
    end
  end
end
