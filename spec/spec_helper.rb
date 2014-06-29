ROOT = Pathname.new(File.expand_path('../../', __FILE__))

$:.unshift((ROOT + 'lib').to_s)
require 'readme-score'

require 'webmock/rspec'

module GithubSpecHelpers
  def stub_github_readme(protocol, repo, user, readme_filename)
    ReadmeScore::Document::Loader::POSSIBLE_README_FILES.each { |file|
      next if readme_filename == file
      raw_url = "#{protocol}://raw.githubusercontent.com/#{repo}/#{user}/master/#{file}"
      stub_request(:get, raw_url).
        to_return(status: 404)
    }
    raw_url = "#{protocol}://raw.githubusercontent.com/#{repo}/#{user}/master/#{readme_filename}"
    stub_request(:get, raw_url)
  end
end

RSpec.configure do |config|
  config.include GithubSpecHelpers
end