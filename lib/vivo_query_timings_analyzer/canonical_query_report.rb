=begin

Group the queries by their canonical forms, and create a report that summarizes
how many of each form were issued and how long they took.

The report looks like this:

-------------------------------------------------------------------------------

Analysis of '/Users/jeb228/Development/Scholars/reasoner/first_assessment/journals_graph/add_journals/scholars.all.log'

Start time:    11:49:57.591
End time:      11:52:52.294
Elapsed time:  00:02:54.703 (174.703)
Query time:    00:02:47.545 (167.545)


            Total Time  Occurences  Average Time  Minimum  Maximum
form   1:      41.827        8814         0.005     0.002    5.890
form   2:      13.403        8814         0.002     0.000    2.409
form   3:      53.422        8814         0.006     0.000    5.916
form   4:      58.893          18         3.272     1.770    5.779
TOTAL:        167.545       26460         0.006

form   1:
[CONSTRUCT { ?url1 ?p ?value } WHERE { GRAPH ?g { ?url1 ?p ?value } FILTER (?g != ?url2) } ]

form   2:
[CONSTRUCT { ?url1 ?inv ?value } WHERE { GRAPH ?gr { ?value ?prop ?url1 } FILTER (isURI(?value)) FILTER (?gr != ?url2) { ?prop ?url3 ?inv } UNION { ?inv ?url3 ?prop } } ]

form   3:
[CONSTRUCT { ?url1 ?p ?o . } WHERE { GRAPH ?url2 { ?url1 ?p ?o . } } ]

form   4:
[]]]

=end

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
      puts
      puts @parameters.label
      puts
      
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
      puts "TOTAL: %14.3f %11d %13.3f" % [total_time, total_count, total_average]
      puts
      
      keys.each_index do |i|
        form = @stats.forms.values[i]
        puts 
        puts "form %3d:" % (i + 1)
        puts  form.canonical_query
      end
      puts 
    end
    
    def total_time
      @stats.forms.values.inject(0.0) { |sum, form| sum += form.total }
    end
    
    def total_count
      total_count = @stats.forms.values.inject(0) { |sum, form| sum += form.count }
    end
    
    def total_average
      total_average = total_count == 0 ? 0.0 : total_time / total_count
    end
  end
end
