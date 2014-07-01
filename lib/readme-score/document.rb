require 'readme-score/document/filter'
require 'readme-score/document/metrics'
require 'readme-score/document/loader'
require 'readme-score/document/parser'
require 'readme-score/document/score'

module ReadmeScore
  class Document
    attr_accessor :html, :filter, :metrics

    def self.load(url)
      loader = Loader.new(url)
      loader.load!
      new(loader.html)
    end

    def initialize(html)
      @html = html
      @noko = Nokogiri::HTML.fragment(@html)
      @metrics = Document::Metrics.new(html_for_analysis)
    end

    # @return [String] HTML string ready for analysis
    def html_for_analysis
      @filter ||= Document::Filter.new(@noko)
      @filter.filtered_html!
    end

    def score
      @score ||= Score.new(metrics)
    end

    def inspect
      "#<#{self.class}>"
    end
  end
end