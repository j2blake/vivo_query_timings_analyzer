module VivoQueryTimingsAnalyzer
  class RecordCollection
    attr_reader :records
    
    def initialize(parser)
      @records = []
      parser.records do |str|
        @records << TimingRecord.new(str)
      end
    end
  end
end
