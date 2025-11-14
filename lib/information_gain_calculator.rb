class InformationGainCalculator
  def initialize(label_property)
    @label_property = label_property
    @entropy_calculator = EntropyCalculator.new(label_property)
    @feature_entropy_calculators = Hash.new do |h, feature|
      h[feature] = Hash.new { |hh, val| hh[val] = EntropyCalculator.new(label_property) }
    end
  end

  def <<(object)
    object.each do |key, value|
      if key == @label_property
        @entropy_calculator << object
      else
        @feature_entropy_calculators[key][value] << object
      end
    end
  end

  def entropy
    @entropy_calculator.entropy
  end

  def information_gains
    total_entropy = entropy
    total_instances = @entropy_calculator.instances
    @feature_entropy_calculators.each_with_object({}) do |(feature, calculators), h|
      h[feature] = total_entropy - calculators.reduce(0) do |acc, (_, calculator)|
        acc + calculator.instances.fdiv(total_instances) * calculator.entropy
      end
    end
  end

  def intrinsic_values
    total_instances = @entropy_calculator.instances
    @feature_entropy_calculators.each_with_object({}) do |(feature, calculators), h|
      h[feature] = calculators.reduce(0) do |acc, (_, calculator)|
        fraction = calculator.instances.fdiv(total_instances)
        acc - fraction * Math.log2(fraction)
      end
    end
  end

  def information_gain_ratios
    information_gains.merge(intrinsic_values) { |_, gain, value| value.zero? ? 0.0 : gain / value }
  end
end
