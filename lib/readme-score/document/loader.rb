require 'uri/http'

module ReadmeScore
  class Document

    class Loader
      MARKDOWN_EXTENSIONS = %w{md mdown markdown}
      class Break < StandardError; end

      def self.github_repo_name(url)
        uri = URI.parse(url)
        return nil unless ["github.com", "www.github.com"].include?(uri.host)
        path_components = uri.path.split("/")
        return nil if path_components.reject(&:empty?).count != 2
        path_components[-2..-1].join("/")
      end

      def self.is_github_repo_slug?(possible_repo)
        !!(/^(\w|-)+\/(\w|-)+$/.match(possible_repo))
      end

      def self.is_url?(possible_url)
        !!(/https?:\/\//.match(possible_url))
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
          @markdown = false
          @response ||= OpenStruct.new.tap {|o|
            @@client ||= Octokit::Client.new(access_token: ENV['READMESCORE_GITHUB_TOKEN'])
            o.body = @@client.readme(github_repo_name, :accept => 'application/vnd.github.html').force_encoding("UTF-8")
          }
        else
          @markdown = MARKDOWN_EXTENSIONS.select {|ext| @url.downcase.end_with?(".#{ext}")}.any?
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