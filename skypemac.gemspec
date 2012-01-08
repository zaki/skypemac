# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "skypemac/version"

Gem::Specification.new do |s|
  s.name        = "skypemac"
  s.version     = Skypemac::VERSION
  s.authors     = ["Zoltan Dezso"]
  s.email       = ["dezso.zoltan@gmail.com"]
  s.homepage    = ""
  s.summary     = %q{Skype Public API client for Mac}
  s.description = %q{Skype Public API client for Mac}

  s.rubyforge_project = "skypemac"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]

  # specify any dependencies here; for example:
  s.add_development_dependency "rspec"
  s.add_development_dependency "rake"
  s.add_runtime_dependency "rb-appscript"
end
