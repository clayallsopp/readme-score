module ReadmeScore
  class Equation

    attr_accessor :constant, :coefficients

    def self.default_equation_path
      File.join(ROOT, 'data', 'equation.json')
    end

    def self.default
      @default ||= begin
        serialized = JSON.parse(IO.read(default_equation_path))
        new(serialized['constant'], serialized['coefficients'])
      end
    end

    def self.save_as_default!(equation)
      serialized = {
        constant: equation.constant,
        coefficients: equation.coefficients
      }
      as_json = JSON.generate(serialized)
      File.open(default_equation_path, 'w') {|f| f.write(as_json) }
    end

    def initialize(constant, coefficients)
      @constant = constant
      @coefficients = coefficients
    end

    def value_for(metrics)
      coefficient_sum = @coefficients.reduce(0) {|memo, (k, v)|
        memo += metrics.send(k) * v
      }
      @constant + coefficient_sum
    end

  end
end