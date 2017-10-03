=begin

So far, it's only an array of records. The tokenizer breaks the stream into
record strings, ignoring anything in between. The TimingRecord constructor
does the actual parsing.

=end

module VivoQueryTimingsAnalyzer
  class RecordCollection
    attr_reader :records
    
    def initialize(tokenizer)
      @records = []
      tokenizer.records do |str|
        @records << TimingRecord.new(str)
      end
    end
  end
end
