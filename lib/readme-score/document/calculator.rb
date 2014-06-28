module ReadmeScore
  class Document
    class Calculator
      def initialize(noko_or_html)
        @noko = Util.to_noko(noko_or_html)
      end

      def number_of_links
        all_links.length
      end

      def number_of_code_blocks
        all_code_blocks.length
      end

      def number_of_paragraphs
        all_paragraphs.length
      end

      def number_of_non_code_sections
        (all_paragraphs + all_lists).length
      end

      def code_block_to_paragraph_ratio
        number_of_code_blocks.to_f / number_of_paragraphs.to_f
      end

      def number_of_internal_links
        all_links.select {|a|
          internal_link?(a)
        }.count
      end

      def number_of_external_links
        all_links.reject {|a|
          internal_link?(a)
        }.count
      end

      private
        def all_links
          @noko.search('a')
        end

        def all_code_blocks
          @noko.search('pre')
        end

        def all_paragraphs
          @noko.search('p')
        end

        def all_lists
          @noko.search('ol') + @noko.search('ul')
        end

        def internal_link?(a)
          external_prefixes = %w{http}
          href = a['href'].downcase

          return true if href.include?("://github") || href.include?("github.io")

          external_prefixes.select {|prefix|
            href.start_with?(prefix)
          }.any?
        end

    end
  end
end