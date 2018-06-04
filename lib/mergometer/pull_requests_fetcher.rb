module Mergometer
  module PullRequestsFetcher
    def search(repos, **options)
      filter = query_from_options(options).map do |o|
        "#{repo_query(repos)} #{o}"
      end
      pull_requests = search_by_query(filter.pop)
      filter.each do |f|
        pull_requests.merge(search_by_query(f))
      end
      pull_requests
    end

    def search_by_query(query)
      @prs = PullRequests.new(Octokit.search_issues(query).items)
    end

    def created_this_week(repos, **options)
      options[:created_at][:from] = Date.today.beginning_of_week.strftime("%F")
      options[:created_at][:to] = Date.today.end_of_week.strftime("%F")
      search(repos, **options)
    end

    def created_last_week(repos, **options)
      options[:created_at][:from] = Date.today.last_week.beginning_of_week.strftime("%F")
      options[:created_at][:to] = Date.today.last_week.end_of_week.strftime("%F")
      search(repos, **options)
    end

    def created_this_month(repos, **options)
      options[:created_at][:from] = Date.today.beginning_of_month.strftime("%F")
      options[:created_at][:to] = Date.today.end_of_month.strftime("%F")
      search(repos, **options)
    end

    def created_last_month(repos, **options)
      options[:created_at][:from] = Date.today.last_month.beginning_of_month.strftime("%F")
      options[:created_at][:to] = Date.today.last_month.end_of_month.strftime("%F")
      search(repos, **options)
    end

    def updated_this_week(repos, **options)
      options[:updated_at][:from] = Date.today.beginning_of_week.strftime("%F")
      options[:updated_at][:to] = Date.today.end_of_week.strftime("%F")
      search(repos, **options)
    end

    def updated_last_week(repos, **options)
      options[:updated_at][:from] = Date.today.last_week.beginning_of_week.strftime("%F")
      options[:updated_at][:to] = Date.today.last_week.end_of_week.strftime("%F")
      search(repos, **options)
    end

    def updated_this_month(repos, **options)
      options[:updated_at][:from] = Date.today.beginning_of_month.strftime("%F")
      options[:updated_at][:to] = Date.today.end_of_month.strftime("%F")
      search(repos, **options)
    end

    def updated_last_month(repos, **options)
      options[:updated_at][:from] = Date.today.last_month.beginning_of_month.strftime("%F")
      options[:updated_at][:to] = Date.today.last_month.end_of_month.strftime("%F")
      search(repos, **options)
    end

    def query_from_options(options)
      options = {
        type: "pr",
        base: "master",
        **options
      }
      if options[:created_at]
        date_query_array(from: options[:created_at][:from], to: options[:created_at][:to]).map do |dq|
          "#{filtered_query(options)} created:#{dq}"
        end
      elsif options[:updated_at]
        date_query_array(from: options[:updated_at][:from], to: options[:updated_at][:to]).map do |dq|
          "#{filtered_query(options)} updated:#{dq}"
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
        "#{date}..#{(req_dates[i + 1] || Date.parse(to) + 1) - 1}"
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
end