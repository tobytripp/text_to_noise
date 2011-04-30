# -*- encoding: utf-8 -*-
lib = File.expand_path( '../lib/', __FILE__ )
$:.unshift lib unless $:.include?( lib )

require 'text_to_noise/version'
Gem::Specification.new do |spec|
  spec.name     = "text-to-noise"
  spec.version  = TextToNoise::VERSION
  spec.platform = Gem::Platform::RUBY

  spec.summary  = "Play sounds based on string matches."
  spec.description = "Pipe a file, like a log file, into text_to_noise and it will play sound effects triggered by regex matches in the input."
  spec.authors  = ["Toby Tripp", "Lydia Tripp"]
  spec.email    = "toby.tripp+tailsounds@gmail.com"
  spec.homepage = "https://github.com/tobytripp/text_to_noise"
  
  spec.required_rubygems_version = ">= 1.3.6"

  spec.add_dependency "rubygame", "~> 2.6.4"

  spec.requirements << "SDL_mixer [http://www.libsdl.org/projects/SDL_mixer/]"

  spec.add_development_dependency "cucumber"
  spec.add_development_dependency "aruba"
  spec.add_development_dependency "rspec"
  
  spec.files         = `git ls-files`.split("\n")
  spec.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  spec.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }

  spec.require_path = 'lib'
end
