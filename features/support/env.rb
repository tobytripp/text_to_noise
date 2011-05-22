require 'aruba/cucumber'
lib = File.expand_path( '../../../lib/', __FILE__ )
$:.unshift lib unless $:.include?( lib )

require 'text_to_noise'

TextToNoise.logger = Logger.new "log/cucumber.log"
TextToNoise.logger.level = Logger::DEBUG
