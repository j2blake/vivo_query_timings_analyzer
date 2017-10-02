module VivoQueryTimingsAnalyzer
  class CanonicalQueryStats
    
    class Form
      attr_reader :canonical_query
      attr_reader :count
      attr_reader :total
      attr_reader :minimum
      attr_reader :maximum
      
      def initialize(canonical_query)
        @canonical_query = canonical_query
        @count = 0
        @total = 0.0 
        @minimum = 1000000.0
        @maximum = 0.0
      end
      
      def increment(r)
        @count += 1
        @total += r.duration
        @minimum = r.duration if r.duration < @minimum
        @maximum = r.duration if r.duration > @maximum
      end
    end
    
    attr_reader :start_time
    attr_reader :end_time
    attr_reader :query_total
    attr_reader :forms
  
    def initialize(record_collection)
      @forms = {}
      @start_time = DateTime.now
      @end_time = DateTime.new(2001)
      @query_total = 0.0
      
      record_collection.records.each do |r|
        @start_time = r.start_time if r.start_time < @start_time
        @end_time = r.end_time if r.end_time > @end_time
        @query_total += r.duration
        
        key = canonicalize_query(r.query)
        @forms[key] = Form.new(key) unless @forms.has_key?(key)
        @forms[key].increment(r)
      end
    end
    
    def canonicalize_query(str)
      # Remove prefixes
      str = str.gsub(/prefix\s+\w+\s*:\s+<[^>]+>/i, "")
      # While string contains a bracketed URI, replace with variable
      index = 1
      while match = /(<[^>]+>)/.match(str)
        str = str.gsub(match[1], "?url#{index}")
        index += 1
      end
      # Replace multi-space with single space
      str = str.gsub(/\s+/, " ")
    end
    
    def elapsed
      @end_time.to_time.to_f - @start_time.to_time.to_f
    end
  end
end
