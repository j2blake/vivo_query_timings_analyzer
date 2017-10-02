module VivoQueryTimingsAnalyzer
  class CanonicalQueryStats
    
    class Form
      attr_reader :canonical_query
      attr_reader :count
      attr_reader :total
      attr_reader :minimum
      attr_reader :maximum
      
      def initialize(canonical_query, count, total, minimum, maximum)
        @canonical_query = canonical_query
        @count = count
        @total = total 
        @minimum = minimum
        @maximum = maximum
        puts "BOGUS CanonicalQueryStats::Form.initialize"
      end
    end
    
    attr_reader :start
    attr_reader :end
    attr_reader :elapsed
    attr_reader :query_total
    attr_reader :forms
  
    def initialize(record_collection)
      @start = Time.now
      @end = Time.now
      @elapsed = Time.now.to_f - Time.new.to_f
      @query_total = 1234.567
      @forms = [Form.new("First canonical query",15,2.66, 0.00, 5.304), Form.new("Second canonical query",3054,4562.66, 2134, 123.001)]
      puts "BOGUS CanonicalQueryStats.initialize"
    end
  end
end
