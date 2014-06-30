module ReadmeScore
  class Document
    class Score

      attr_accessor :text_metrics, :bonus_metrics

      def initialize(text_metrics, bonus_metrics)
        @text_metrics = text_metrics
        @bonus_metrics = bonus_metrics
      end

      def text_score
        equation_value = Equation.default.value_for(@text_metrics)
        [100.0, equation_value].min
      end

      def bonus_scores
        @@bonuses ||= {
          has_gifs: 10,
          has_tables: 10
        }
        Hash[@@bonuses.map {|k, v|
          qualifies_for_bonus = bonus_metrics.send("#{k}?")
          [k, qualifies_for_bonus ? v : 0]
        }.select {|_, v|
          v > 0
        }]
      end

      def bonus_score
        bonus_scores.reduce(0) {|memo, (_, v)|
          memo += v
        }
      end

      def total_score
        text_score + bonus_score
      end
      alias_method :to_i, :total_score

      def to_f
        to_i.to_f
      end
    end
  end
end