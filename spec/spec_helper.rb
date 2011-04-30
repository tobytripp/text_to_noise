require 'rspec'

lib = File.expand_path( '../lib/', __FILE__ )
$:.unshift lib unless $:.include?( lib )

require 'text_to_noise'
TextToNoise.logger.level = Logger::WARN

Rspec.configure do |c|
  c.mock_with :rspec
end
