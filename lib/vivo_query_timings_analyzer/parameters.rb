module VivoQueryTimingsAnalyzer
  class Parameters
    attr_reader :label
    attr_reader :input_files
  
    def initialize(args)
      raise UserInputError.new("You must specify input file(s)") unless args[0]
      @input_files = Dir.glob(args[0]) 
      raise UserInputError.new("Can't find any files at: '#{args[0]}'") unless @input_files.length > 0
      
      @label = "Analysis of '#{args[0]}'"

    end
  end
end
