module VivoQueryTimingsAnalyzer
  attr_reader :parameters
  attr_reader :stats
  
  class CanonicalQueryReport
    def initialize(parameters, stats)
      @parameters = parameters
      @stats = stats
    end
    
    def format_interval(interval)
      with_commas = insert_commas("%.3f" % interval)
      millis = (interval.to_f - interval.to_i) * 1000
      seconds = interval.to_i % 60
      minutes = interval.to_i / 60 % 60
      hours = interval.to_i / 3600 % 3600
      "%02d:%02d:%02d.%03d (%s)" % [hours, minutes, seconds, millis, with_commas]
    end
    
    def insert_commas(number_string)
      parts = number_string.split('.')
      parts[0].gsub!(/(\d)(?=(\d\d\d)+(?!\d))/, "\\1,")
      parts.join('.')
    end
    
    def write
      puts @parameters.label
      puts
      puts "Start time:    %s" % @stats.start_time.strftime("%T.%L")
      puts "End time:      %s" % @stats.end_time.strftime("%T.%L")
      puts "Elapsed time:  %s" % format_interval(@stats.elapsed)
      puts "Query time:    %s" % format_interval(@stats.query_total)

      puts
      puts
      puts "            Total Time  Occurences  Average Time  Minimum  Maximum"
      keys = @stats.forms.keys.sort
      keys.each_index do |i|
        form = @stats.forms[keys[i]]
        average = form.count == 0 ? 0.0 : form.total / form.count
        puts "form %3d: %11.3f %11d %13.3f %9.3f %8.3f" % [i + 1, form.total, form.count, average, form.minimum, form.maximum]  
      end
      
      total_time = @stats.forms.values.inject(0.0) { |sum, form| sum += form.total }
      total_count = @stats.forms.values.inject(0) { |sum, form| sum += form.count }
      total_average = total_count == 0 ? 0.0 : total_time / total_count
      puts "TOTAL: %14.3f %11d %13.3f" % [total_time, total_count, total_average]
      
      keys.each_index do |i|
        form = @stats.forms.values[i]
        puts 
        puts "form %3d:" % (i + 1)
        puts  form.canonical_query
      end
      puts 
    end
  end
end

=begin
Label is the way that it will be known

Start time:    12:00:00.000
End time:      12:00:00.000
Elapsed time:   0:00:00.000 (0,000,000.000)
Query time:     0:00:00.000 (  000,000.000)


            Total Time  Occurences  Average Time  Maximum  Minimum
form   1:     000.000       12345       000.000   000.000  000.000
form   2:     000.000       12345       000.000   000.000  000.000
TOTAL:       0000.000      123456       000.000


Form   1:
SELECT blah blah blah

Form.  2:
PREFIX this that the other all in one line.



----------------------------------

Parameters.label

CanonicalQueryStats.forms, start, end, elapsed, query_total
CanonicalQueryStats::Form.query, count, total
=end