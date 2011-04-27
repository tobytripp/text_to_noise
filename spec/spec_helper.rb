require 'rspec'

lib = File.expand_path( '../lib/', __FILE__ )
$:.unshift lib unless $:.include?( lib )
require 'tail_sounds'

Rspec.configure do |c|
  c.mock_with :rspec
end
