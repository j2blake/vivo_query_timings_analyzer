=begin
--------------------------------------------------------------------------------

Build a collection of timing records, then summarize and produce a report.

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
=end

$: << File.dirname(File.expand_path(__FILE__))

require 'date'

require 'vivo_query_timings_analyzer/parameters'
require 'vivo_query_timings_analyzer/input_source'
require 'vivo_query_timings_analyzer/raw_record_tokenizer'
require 'vivo_query_timings_analyzer/timing_record'
require 'vivo_query_timings_analyzer/record_collection'
require 'vivo_query_timings_analyzer/canonical_query_stats'
require 'vivo_query_timings_analyzer/canonical_query_report'

module VivoQueryTimingsAnalyzer
  # What did you ask for?
  class UserInputError < StandardError
  end

  class Main
    def run
      begin
        @parameters = Parameters.new(ARGV)
         
        @input_source = InputSource.new(@parameters)
        @tokenizer = RawRecordTokenizer.new(@input_source)
        @records = RecordCollection.new(@tokenizer)
        
        @stats = CanonicalQueryStats.new(@records)
        @report = CanonicalQueryReport.new(@parameters, @stats)  
        @report.write
      rescue UserInputError
        puts
        puts "ERROR: #{$!}"
        puts
        exit 1
      end
    end
  end
end
