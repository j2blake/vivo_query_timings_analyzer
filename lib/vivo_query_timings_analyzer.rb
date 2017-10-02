=begin
--------------------------------------------------------------------------------

Parse the Parameters.
Create the InputSource
Create Records from the InputSource, includes parsing and canonicalizing
Create CanonicalQueryStats from Records
Print CanonicalQueryReport
Do something

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------
=end

$: << File.dirname(File.expand_path(__FILE__))

require 'date'

require 'vivo_query_timings_analyzer/parameters'
require 'vivo_query_timings_analyzer/input_source'
require 'vivo_query_timings_analyzer/raw_record_parser'
require 'vivo_query_timings_analyzer/record_collection'
require 'vivo_query_timings_analyzer/canonical_query_stats'
require 'vivo_query_timings_analyzer/canonical_query_report'

module VivoQueryTimingsAnalyzer
  # What did you ask for?
  class UserInputError < StandardError
  end

  class Main
    def initialize
    # Nothing yet
    end

    def run
      begin
        @parameters = Parameters.new(ARGV) 
        @input_source = InputSource.new(@parameters)
        @parser = RawRecordParser.new(@input_source)
        @records = RecordCollection.new(@parser)
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
