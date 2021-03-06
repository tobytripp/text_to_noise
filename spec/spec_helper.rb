require 'rspec'

lib = File.expand_path( '../lib/', __FILE__ )
$:.unshift lib unless $:.include?( lib )

require 'text_to_noise'
TextToNoise.logger = Logger.new "log/test.log"
TextToNoise.logger.level = Logger::DEBUG

Rspec.configure do |c|
  c.mock_with :rspec
end
