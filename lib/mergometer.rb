require "octokit"
require "mergometer/version"
require "mergometer/configuration"
require "mergometer/pull_request"
require "mergometer/ranking"
require "mergometer/report"

module Mergometer
  Configuration.new.apply
  Report.new("cookpad/global-web", metric: :comment_count).render
end
