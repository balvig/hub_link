require "octokit"
require "mergometer/version"
require "mergometer/configuration"
require "mergometer/pull_request"
require "mergometer/ranking"
require "mergometer/report"

module Mergometer
  Configuration.new(cache_time: 24 * 3600).apply
  Report.new("cookpad/global-web", metrics: %i(total_pr_count quick_fix_count eligible_pr_count long_running_count heavily_commented_count problem_ratio)).render
end
