# -*- encoding: utf-8 -*-
lib = File.expand_path( '../lib/', __FILE__ )
$:.unshift lib unless $:.include?( lib )

require 'tail_sounds/version'
Gem::Specification.new do |spec|
  spec.name     = "tail_sounds"
  spec.version  = TailSounds::VERSION
  spec.platform = Gem::Platform::RUBY

  spec.summary  = "Play sounds based on string matches."
  spec.description = "Pipe a file, like a log file, into tail_sounds and it will play sound effects triggered by regex matches in the input."
  spec.authors  = ["Toby Tripp"]
  spec.email    = "toby.tripp+tailsounds@gmail.com"
  
  spec.required_rubygems_version = ">= 1.3.6"

  spec.add_dependency "rubygame", "~> 2.6.4"
  spec.add_development_dependency "rspec"
  
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  spec.require_path = 'lib'
end
