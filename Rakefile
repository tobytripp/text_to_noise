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

require 'cucumber/rake/task'
namespace :cucumber do
    Cucumber::Rake::Task.new( :ok, 'Run features that should pass' ) do |t|
      t.fork = true
      t.profile = 'default'
    end

    Cucumber::Rake::Task.new( :wip, 'Run features that are being worked on' ) do |t|
      t.fork = true # You may get faster startup if you set this to false
      t.profile = 'wip'
  end
end
desc 'Alias for cucumber:ok'
task :cucumber => 'cucumber:ok'

task :default => [:spec, :cucumber]