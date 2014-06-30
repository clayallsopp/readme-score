require 'readme-score/document/filter'
require 'readme-score/document/metrics'
require 'readme-score/document/loader'
require 'readme-score/document/parser'
require 'readme-score/document/score'

module ReadmeScore
  class Document
    attr_accessor :html, :filter, :text_metrics, :bonus_metrics

    def self.load(url)
      loader = Loader.new(url)
      loader.load!
      new(loader.html)
    end

    def initialize(html)
      @html = html
      @noko = Nokogiri::HTML.fragment(@html)
      @text_metrics = Document::Metrics.new(html_for_analysis)
      @bonus_metrics = Document::Metrics.new(@html)
    end

    # @return [String] HTML string ready for analysis
    def html_for_analysis
      @filter ||= Document::Filter.new(@noko)
      @filter.filtered_html!
    end

    def score
      @score ||= Score.new(text_metrics, bonus_metrics)
    end
  end
end