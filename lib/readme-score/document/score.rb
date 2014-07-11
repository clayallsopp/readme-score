module ReadmeScore
  class Document
    class Score

      SCORE_METRICS = [
        {
          metric: :number_of_code_blocks,
          value_per: 5,
          max: 40
        },
        {
          metric: :number_of_non_code_sections,
          value_per: 5,
          max: 30
        },
        {
          metric: :has_lists?,
          value: 10
        },
        {
          metric: :number_of_images,
          value_per: 5,
          max: 15
        },
        {
          metric: :number_of_gifs,
          value_per: 5,
          max: 15
        },
        {
          metric: :cumulative_code_block_length,
          value_per: 0.0009475244447271192,
          max: 10
        },
        {
          metric_name: :low_code_block_penalty,
          metric: :number_of_code_blocks,
          if_less_than: 3,
          value: -10
        }
      ]

      attr_accessor :metrics

      def initialize(metrics)
        @metrics = metrics
      end

      def score_breakdown
        breakdown = {}
        SCORE_METRICS.each { |h|
          metric_option = OpenStruct.new(h)
          metric_name = metric_option.metric_name || metric_option.metric
          metric_score_value = 0
          # points for each occurance
          if metric_option.value_per
            metric_score_value = [metrics.send(metric_option.metric) * metric_option.value_per, metric_option.max].min
          elsif metric_option.if_less_than
            if metrics.send(metric_option.metric) < metric_option.if_less_than
              metric_score_value = metric_option.value
            end
          else
            metric_score_value = metrics.send(metric_option.metric) ? metric_option.value : 0
          end
          breakdown[metric_name] = metric_score_value
        }
        breakdown
      end
      alias_method :breakdown, :score_breakdown

      def total_score
        score = 0
        score_breakdown.each {|metric, points|
          score += points.to_i
        }
        [[score, 100].min, 0].max
      end
      alias_method :to_i, :total_score

      def to_f
        to_i.to_f
      end

      def inspect
        "#<#{self.class} - #{total_score}>"
      end
    end
  end
end