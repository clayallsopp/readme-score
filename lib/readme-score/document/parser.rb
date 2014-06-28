module ReadmeScore
  class Document
    class Parser
      def initialize(markdown)
        @markdown = markdown
      end

      def to_html
        parser.render(@markdown)
      end

      def parser
        @@parser ||= Redcarpet::Markdown.new(
          Redcarpet::Render::HTML,
          no_intra_emphasis: true,
          autolink: true,
          fenced_code_blocks: true,
          tables: true,
          strikethrough: true
        )
      end
    end
  end
end