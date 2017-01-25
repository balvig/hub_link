require "octokit"
require "mergometer/version"
require "mergometer/configuration"
require "mergometer/pull_request"
require "mergometer/ranking"
require "mergometer/report"

module Mergometer
  Configuration.new(cache_time: 72 * 3600).apply
  Report.new("cookpad/global-web", metrics: %i(eligible_pr_count comment_count changes heavily_commented_count problem_ratio)).render
end
