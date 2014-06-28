require 'readme-score/document/filter'
require 'readme-score/document/calculator'
require 'readme-score/document/loader'
require 'readme-score/document/parser'

module ReadmeScore
  class Document
    attr_accessor :html, :filter, :calculator

    def initialize(html)
      @html = html
      @noko = Nokogiri::HTML.fragment(@html)
      @filter = Document::Filter.new(@noko)
      @calculator = Document::Calculator.new(@noko)
    end

    # @return [String] HTML string ready for analysis
    def html_for_analysis
      @filter.filtered_html!
    end
  end
end