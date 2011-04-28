# Run me with:
#   watchr watchr.rb
#
# I will automatically run the relevant specs when you change things.
# Aren't I convenient?
#
begin
  require "g"
rescue LoadError
end

def announce( message )
  puts message
  g message if Kernel.respond_to? :g
end

def spec( *files )
  announce "Running specs: #{files}"
  execute "rspec #{files.join " "} --options spec/spec.opts"
end

def specs_matching( type, name )
  puts "looking for specs of #{name}"
  matching_specs = Dir["spec/**/*#{name}*_spec.rb"]
  if matching_specs.empty?
    $stderr.puts "No matching specs found!  Did you NOT TEST THIS?!"
  else
    spec *matching_specs
  end
end

def run_all_tests
  announce "Running full test suite"
  execute "rake"
end

def execute( cmd )
  puts "> #{cmd}"
  system cmd
end

watch( '^spec/[^/]*/(.*)_spec\.rb'     ) { |m| spec m[0] }
watch( '^spec/spec_helper\.rb'         ) { |m| execute "rake spec" }
watch( '^spec/support/.*'              ) { |m| execute "rake spec" }
watch( '^lib/([^/]+)/(.*)\.rb'         ) { |m| specs_matching m[1], m[2]   }
watch( '^features/step_definitions/.*' ) { |m| execute "cucumber features" }
watch( '^features/([^/]+\.feature)'     ) { |m|
  execute "cucumber #{m[0]}" unless m[1].include? "step_definitions"
}

Signal.trap 'INT' do
  if @sent_an_int then
    puts "   A second INT?  Ok, I get the message.  Shutting down now."
    exit
  else
    puts "   Did you just send me an INT? Ugh.  I'll quit for real if you do it again."
    @sent_an_int = true
    Kernel.sleep 1.5
    run_all_tests
  end
end

# Ctrl-\
Signal.trap 'QUIT' do
  run_all_tests
end
