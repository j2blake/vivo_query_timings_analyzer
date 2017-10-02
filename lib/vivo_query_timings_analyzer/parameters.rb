module VivoQueryTimingsAnalyzer
  class Parameters
    attr_reader :label
  
    def initialize(args)
      @label = "TOTALLY BOGUS LABEL"
      puts "BOGUS Parameters.initialize"
    end
  end
end
