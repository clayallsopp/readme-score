module ReadmeScore
  module Util
    module_function
    def to_noko(noko_or_html, copy = false)
      noko = noko_or_html
      if noko_or_html.is_a?(String)
        noko = Nokogiri::HTML.fragment(noko_or_html)
      elsif copy && noko_or_html.is_a?(Nokogiri::XML::Node)
        noko = Nokogiri::HTML.fragment(noko.to_s)
      end
      noko
    end
  end
end