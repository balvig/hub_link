module HubLink
  module Api
    class Issue < SimpleDelegator
      require "hub_link/slicer"
      require "hub_link/api/pull_request"

      EXPORT_COLUMNS = %i(
        id
        title
        number
        created_at
        updated_at
        closed_at
        submitter
        labels
        repo
        html_url
        state
      )

      def self.list(repo:, page:, **options)
        Octokit.list_issues(repo, options.merge(page: page, sort: "updated", direction: "asc", state: "all")).map do |item|
          item.repo = repo
          new_from_api(item)
        end
      end

      def self.new_from_api(item)
        if item.respond_to?(:pull_request)
          PullRequest.new(item)
        else
          Issue.new(item)
        end
      end

      def pull_request?
        false
      end

      def submitter
        user.login
      end

      def labels
        super.map(&:name).join(", ")
      end

      def to_h
        Slicer.new(self, columns: export_columns).to_h
      end

      private

        def export_columns
          EXPORT_COLUMNS
        end
    end
  end
end
