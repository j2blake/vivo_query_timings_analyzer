module VivoQueryTimingsAnalyzer
  class TimingRecord
    attr_reader :start_time
    attr_reader :end_time
    attr_reader :duration
    attr_reader :query
    
    def initialize(str)
      match = /^([-:,\s\d]+)
               .*\[RDFServiceLogger\]\s+
               ([.\d]+)
               .*
               (\[.*\])
              /x.match(str)
      @end_time = DateTime.strptime(match[1], "%Y-%m-%d %H:%M:%S,%L")
      @duration = match[2].to_f
      @start_time = @end_time - (@duration / 86400.0)
      @query = match[3]
    end
    
    def to_s
      "TimingRecord[start_time=#{@start_time.strftime("%D %T.%L")}, end_time=#{@end_time.strftime("%D %T.%L")}, duration=#{@duration}, query=#{@query}"
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

Time.strptime("2000-10-31", "%Y-%m-%d")
=end