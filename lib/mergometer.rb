require "octokit"
require "mergometer/version"
require "mergometer/configuration"
require "mergometer/pull_request"
require "mergometer/ranking"
require "mergometer/report"

module Mergometer
  Configuration.new(cache_time: 24 * 3600).apply
  Report.new("cookpad/global-web", metrics: %i(comment_count merge_time)).render
end
