=begin

Ask for the records, and it will go through the input source, chunking the lines
that are in timing records, and ignoring the other lines.

A timing record looks like this (including the blank line at the end), or the 
stack trace may be omitted:

------------------------------------------------------------------------------

2017-10-02 11:43:35,773 INFO  [RDFServiceLogger]    0.002 sparqlConstructQuery [CONSTRUCT {      <http://scholars.cornell.edu/individual/bogusGuy> ?p ?value  } WHERE {      GRAPH ?g {          <http://scholars.cornell.edu/individual/bogusGuy> ?p ?value      }      FILTER (?g != <http://vitro.mannlib.cornell.edu/default/vitro-kb-inf>) }  ]    edu.cornell.mannlib.vitro.webapp.rdfservice.impl.logging.LoggingRDFService.sparqlConstructQuery(LoggingRDFService.java:53) 
   edu.cornell.mannlib.vitro.webapp.reasoner.ABoxRecomputer.getAssertions(ABoxRecomputer.java:317) 
   edu.cornell.mannlib.vitro.webapp.reasoner.ABoxRecomputer.recomputeIndividual(ABoxRecomputer.java:218) 
   edu.cornell.mannlib.vitro.webapp.reasoner.ABoxRecomputer.recomputeIndividuals(ABoxRecomputer.java:173) 
   edu.cornell.mannlib.vitro.webapp.reasoner.ABoxRecomputer.recomputeIndividuals(ABoxRecomputer.java:153) 
   edu.cornell.mannlib.vitro.webapp.reasoner.ABoxRecomputer.recompute(ABoxRecomputer.java:140) 
   edu.cornell.mannlib.vitro.webapp.reasoner.SimpleReasoner.recomputeIndividuals(SimpleReasoner.java:233) 
   edu.cornell.mannlib.vitro.webapp.reasoner.SimpleReasoner.notifyModelChange(SimpleReasoner.java:180) 
   edu.cornell.mannlib.vitro.webapp.rdfservice.impl.RDFServiceImpl.notifyListeners(RDFServiceImpl.java:142) 
   edu.cornell.mannlib.vitro.webapp.rdfservice.impl.RDFServiceImpl.notifyListenersOfChanges(RDFServiceImpl.java:133) 
   edu.cornell.mannlib.vitro.webapp.rdfservice.impl.jena.sdb.RDFServiceSDB.changeSetUpdate(RDFServiceSDB.java:91) 
   edu.cornell.mannlib.vitro.webapp.rdfservice.impl.logging.LoggingRDFService.changeSetUpdate(LoggingRDFService.java:39) 
   edu.cornell.mannlib.vitro.webapp.controller.jena.RDFUploadController.readIntoModel(RDFUploadController.java:427) 
   edu.cornell.mannlib.vitro.webapp.controller.jena.RDFUploadController.doLoadRDFData(RDFUploadController.java:405) 
   edu.cornell.mannlib.vitro.webapp.controller.jena.RDFUploadController.loadRDF(RDFUploadController.java:284) 
   edu.cornell.mannlib.vitro.webapp.controller.jena.RDFUploadController.doPost(RDFUploadController.java:93) 
   javax.servlet.http.HttpServlet.service(HttpServlet.java:646) 
   javax.servlet.http.HttpServlet.service(HttpServlet.java:727) 
   edu.cornell.mannlib.vitro.webapp.controller.VitroHttpServlet.service(VitroHttpServlet.java:71) 
   org.apache.catalina.core.ApplicationFilterChain.internalDoFilter(ApplicationFilterChain.java:303) 
   ...

=end

module VivoQueryTimingsAnalyzer
  class RawRecordTokenizer
    def initialize(input_source)
      @input_source = input_source
      @buffer = []
    end
    
    def records(&block)
      @block = block
      @input_source.lines do |line|
        @line = line
        if not_in_a_timing_record
          if timing_record_begins
            start_new_record
          else
            ignore_the_line
          end
        else # in a timing record
          if timing_record_continues
            add_line_to_record
          else
            dump_timing_record
            unget_the_line
          end
        end
      end
      
      # any left over?
      dump_timing_record
    end
    
    def not_in_a_timing_record
      @buffer.empty?
    end
    
    def timing_record_begins
      /\[RDFServiceLogger\]/ =~ @line
    end
    
    def start_new_record
      @buffer = [@line]
    end
    
    def ignore_the_line
      # ignored
    end
    
    def timing_record_continues
      /^\s+/ =~ @line
    end
    
    def add_line_to_record
      @buffer << @line
    end
    
    def dump_timing_record
      if !@buffer.empty?
        @block.call(@buffer.join)
        @buffer = []
      end
    end
    
    def unget_the_line
      @input_source.unget(@line)
    end
  end
end

