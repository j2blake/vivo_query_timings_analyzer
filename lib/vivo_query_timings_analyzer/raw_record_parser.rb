=begin

Ask for the records, and it will go through the input source, ignoring any lines
that are not parts of timing records and chunking any lines that are.

=end

module VivoQueryTimingsAnalyzer
  class RawRecordParser
    def initialize(input_source)
      @input_source = input_source
      @buffer = []
    end
    
    def records(&block)
      @input_source.lines do |line|
        if @buffer.empty?
          if /\[RDFServiceLogger\]/ =~ line
            # start the buffer
            give_it_up &block
            @buffer << line
          else
            # ignore this line
          end
        else
          if line.strip.empty?
            # end of record
            give_it_up &block
          elsif /^\d{4}/ =~ line
            # passed the end of the record
            give_it_up &block
            @input_source.unget(line)
          else
            # record continues
            @buffer << line
          end
        end
      end
      # any left over?
      give_it_up &block
    end
    
    def give_it_up(&block)
      if !@buffer.empty?
        block.call(@buffer.join)
        @buffer = []
      end
    end
  end
end

=begin

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

2017-10-02 11:43:35,785 INFO  [RDFServiceLogger]    0.007 sparqlConstructQuery [CONSTRUCT {      <http://scholars.cornell.edu/individual/bogusGuy> ?inv ?value  } WHERE {      GRAPH ?gr {   

=end