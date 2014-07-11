require 'nokogiri'
require 'unirest'
require 'redcarpet'
require 'octokit'

require 'json'

require "readme-score/version"
require "readme-score/util"
require "readme-score/document"

module ReadmeScore
  ROOT = File.expand_path(File.join(File.dirname(__FILE__), ".."))

  module_function
  def for(url_or_html)
    document(url_or_html).score
  end

  def document(url_or_html)
    document = nil
    if Document::Loader.is_url?(url_or_html)
      document = Document.load(url_or_html)
    elsif Document::Loader.is_github_repo_slug?(url_or_html)
      document = Document.load("http://github.com/#{url_or_html}")
    else
      document = Document.new(url_or_html)
    end
    document
  end

  def use_github_api?
    !@reject_github_api
  end

  def use_github_api=(use_github_api)
    @reject_github_api = !use_github_api
  end

  def github_api_token=(github_api_token)
    @github_api_token = github_api_token
  end

  def github_api_token
    @github_api_token || ENV['READMESCORE_GITHUB_TOKEN']
  end
end
