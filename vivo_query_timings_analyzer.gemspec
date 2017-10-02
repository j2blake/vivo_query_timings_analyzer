# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

Gem::Specification.new do |spec|
  spec.name          = "vivo_query_timings_analyzer"
  spec.version       = '1.0'
  spec.authors       = ["Jim Blake"]
  spec.email         = ["jeb228@cornell.edu"]
  spec.summary       = %q{Analyze timing records in VIVO log files}
  spec.description   = %q{Scan one or more VIVO logs, analyzing the query timing records from the developer panel.}
  spec.homepage      = "http://scholars.cornell.edu/"
  spec.license       = "MIT"

  spec.files         = ['lib/vivo_query_timings_analyzer.rb']
  spec.executables   = ['bin/vivo_query_timings_analyzer']
  spec.test_files    = ['tests/test_vivo_query_timings_analyzer.rb']
  spec.require_paths = ["lib"]
end
