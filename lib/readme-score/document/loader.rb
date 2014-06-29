require 'uri/http'

module ReadmeScore
  class Document

    def self.load(url)
      loader = Loader.new(url)
      loader.load!
      new(loader.html)
    end

    class Loader
      POSSIBLE_README_FILES = ["README.md", "readme.md"]
      class Break < StandardError; end

      def initialize(url)
        @url = url
      end

      def request_url
        # detect github repo URLs
        @request_url ||= begin
          begin
            uri = URI.parse(@url)
            raise Break unless ["github.com", "www.github.com"].include?(uri.host)
            raise Break if uri.path.split("/").reject(&:empty?).count != 2
            uri.host = "raw.githubusercontent.com"
            original_path = uri.path
            use_url = nil
            POSSIBLE_README_FILES.each {|f|
              uri.path = File.join(original_path, "master/#{f}")
              use_url = uri.to_s if valid_url?(uri.to_s)
              break if use_url
            }
            raise Break unless use_url
            return use_url
          rescue URI::InvalidURIError
          rescue Break
          end

          @url
        end
      end

      def load!
        @response ||= Unirest.get request_url
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
        request_url.downcase.end_with?(".md")
      end

      private
        def valid_url?(url)
          @response = Unirest.get(url)
          @response.code == 200
        end
    end
  end
end