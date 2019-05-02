require 'uri/http'

require 'readme-score/document/loader/github_readme_finder'

module ReadmeScore
  class Document

    class Loader
      MARKDOWN_EXTENSIONS = %w{md mdown markdown}

      attr_accessor :request, :markdown

      def self.github_repo_name(url)
        uri = URI.parse(url)
        return nil unless ["github.com", "www.github.com"].include?(uri.host)
        path_components = uri.path.split("/")
        return nil if path_components.reject(&:empty?).count != 2
        path_components[-2..-1].join("/")
      end

      def self.is_github_repo_slug?(possible_repo)
        !!(/^(\w|-)+\/(\w|-|\.)+$/.match(possible_repo))
      end

      def self.is_url?(possible_url)
        !!(/https?:\/\//.match(possible_url))
      end

      def self.markdown_url?(url)
        MARKDOWN_EXTENSIONS.select {|ext| url.downcase.end_with?(".#{ext}")}.any?
      end

      attr_accessor :response

      def initialize(url)
        @url = url
      end

      def github_repo_name
        Loader.github_repo_name(@url)
      end

      def load!
        if github_repo_name
          if ReadmeScore.use_github_api?
            load_via_github_api!
          else
            # take a guess at the raw file name
            load_via_github_approximation!
          end
        else
          @markdown = Loader.markdown_url?(@url)
          @response ||= OpenStruct.new.tap {|o|
            o.body = Net::HTTP.get(URI(@url))
          }
        end
      end

      def load_via_github_api!
        @markdown = false
        @response ||= OpenStruct.new.tap {|o|
          @@client ||= Octokit::Client.new(access_token: ReadmeScore.github_api_token)
          o.body = @@client.readme(github_repo_name, :accept => 'application/vnd.github.html').force_encoding("UTF-8")
        }
      end

      def load_via_github_approximation!
        @github_approximation_url ||= GithubReadmeFinder.new(url).find_url
        @markdown = Loader.markdown_url?(@github_approximation_url)
        @response ||= OpenStruct.new.tap {|o|
          o.body = Net::HTTP.get(URI(@github_approximation_url))
        }
      end

      def html
        if markdown?
          parse_markdown(@response.body)
        else
          @response.body
        end
      end

      def parse_markdown(markdown)
        Parser.new(@response.body).to_html
      end

      def markdown?
        @markdown == true
      end
    end
  end
end