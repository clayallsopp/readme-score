require 'uri/http'

module ReadmeScore
  class Document

    class Loader
      POSSIBLE_README_FILES = ["README.md", "readme.md", "ReadMe.md"]
      class Break < StandardError; end

      attr_accessor :response

      def initialize(url)
        @url = url
      end

      def github_repo_name
        uri = URI.parse(@url)
        return nil unless ["github.com", "www.github.com"].include?(uri.host)
        path_components = uri.path.split("/")
        return nil if path_components.reject(&:empty?).count != 2
        path_components[-2..-1].join("/")
      end

      def load!
        if github_repo_name
          @markdown = false
          @response ||= OpenStruct.new.tap {|o|
            @@client ||= Octokit::Client.new(access_token: ENV['READMESCORE_GITHUB_TOKEN'])
            o.body = @@client.readme(github_repo_name, :accept => 'application/vnd.github.html').force_encoding("UTF-8")
          }
        else
          @markdown = @url.downcase.end_with?(".md")
          @response ||= Unirest.get @url
        end
      end

      def html
        if markdown?
          # parse
          Parser.new(@response.body).to_html
        else
          @response.body
        end
      end

      def markdown?
        @markdown == true
      end
    end
  end
end