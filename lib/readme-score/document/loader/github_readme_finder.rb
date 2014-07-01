require 'net/http'

module ReadmeScore
  class Document
    class Loader
      class GithubReadmeFinder
        POSSIBLE_README_FILES = %w{README.md readme.md README readme ReadMe ReadMe.md}

        def initialize(github_repo_url)
          @repo_url = github_repo_url
        end

        def find_url
          uri = URI.parse(@repo_url)
          uri.scheme = "https"
          uri.host = "raw.githubusercontent.com"
          original_path = uri.path
          readme_url = nil
          POSSIBLE_README_FILES.each {|f|
            uri.path = File.join(original_path, "master/#{f}")
            readme_url = uri.to_s if reachable?(uri.to_s)
            break if readme_url
          }
          readme_url
        end

        private
          def reachable?(url)
            begin
              RestClient::Request.execute(method: :head, url: url)
              true
            rescue RestClient::Exception
              false
            end
          end
      end
    end
  end
end