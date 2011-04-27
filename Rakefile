$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "tail_sounds/version"

namespace :gem do
  task :build do
    system "gem build tail_sounds.gemspec"
  end
 
  task :release => :build do
    system "gem push tail_sounds-#{TailSounds::VERSION}"
  end
end

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

task :default => :spec
