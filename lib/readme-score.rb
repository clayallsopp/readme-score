require 'nokogiri'
require 'unirest'
require 'redcarpet'
require 'octokit'

require 'json'

require "readme-score/version"
require "readme-score/util"
require "readme-score/document"
require "readme-score/equation"

module ReadmeScore
  ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))
end
