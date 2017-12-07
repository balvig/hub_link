require "octokit"
require "mergometer/version"
require "mergometer/configuration"
require "mergometer/ranking_report"
require "mergometer/weekly_report"
require "mergometer/review_report"
require "mergometer/merge_time_report"

module Mergometer
  Configuration.new(cache_time: 72 * 3600).apply
  # RankingReport.new("cookpad/global-web").render
  # WeeklyReport.new("cookpad/global-web").render
  # ReviewReport.new("cookpad/global-web").render
  MergeTimeReport.new("cookpad/global-web").render
end
