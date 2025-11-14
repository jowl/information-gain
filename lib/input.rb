class Input
  class JsonData
    def initialize(input)
      @input = input
    end

    def each(&block)
      @input.each do |line|
        yield JSON.parse(line)
      end
    end
  end

  class CsvData
    def initialize(input)
      @input = input
    end

    def each(&block)
      csv = CSV.new(@input, headers: true)
      csv.each(&block)
    end
  end

  class TsvData < CsvData
    def each(&block)
      tsv = CSV.new(@input, headers: true, col_sep: "\t")
      tsv.each(&block)
    end
  end

  def self.create(type, input)
    case type
    when :csv then CsvData.new(input)
    when :tsv then TsvData.new(input)
    when :json then JsonData.new(input)
    end
  end
end
