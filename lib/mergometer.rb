require "octokit"
require "facets/math"

require "extensions"

require "mergometer/version"
require "mergometer/pull_request"
require "mergometer/ranking"
require "mergometer/report"

module Mergometer
  # Octokit.auto_paginate = true
  Report.new("cookpad/global-web").render
end
