ROOT = Pathname.new(File.expand_path('../../', __FILE__))

$:.unshift((ROOT + 'lib').to_s)
require 'readme-score'

require 'webmock/rspec'

module GithubSpecHelpers
  def stub_github_readme(protocol, repo, user, readme_filename)
    stub_request(:get, "https://api.github.com/repos/#{repo}/#{user}/readme").
         with(:headers => {'Accept'=>'application/vnd.github.html', 'Accept-Encoding'=>'gzip;q=1.0,deflate;q=0.6,identity;q=0.3', 'User-Agent'=>'Octokit Ruby Gem 3.2.0'})
  end
end

RSpec.configure do |config|
  config.include GithubSpecHelpers
end