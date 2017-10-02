=begin

Get an unbroken stream of lines from one or more input files.

Use unget as needed to push lines back onto the stack.

=end 
module VivoQueryTimingsAnalyzer
  class InputSource
    def initialize(parameters)
      @paths = parameters.input_files
      @line_buffer = []
    end
    
    def unget(line)
      @line_buffer.unshift(line)
    end
    
    def lines
      @paths.each do |path|
        File.open(path) do |f|
          f.each do |line|
            while @line_buffer.length > 0
              yield @line_buffer.shift
            end
            yield line
          end
        end
      end
    end
  end
end
