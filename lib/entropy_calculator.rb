class EntropyCalculator
  def initialize(label_property)
    @label_property = label_property
    @label_counts = Hash.new(0)
  end

  def <<(object)
    @label_counts[object[@label_property]] += 1
  end

  def labels
    @label_counts.keys
  end

  def instances
    @label_counts.values.reduce(:+)
  end

  def entropy
    total = instances
    @label_counts.reduce(0) do |acc, (_, count)|
      fraction = count.fdiv(total)
      acc - fraction * Math.log2(fraction)
    end
  end
end
