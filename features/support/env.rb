require 'aruba/cucumber'
lib = File.expand_path( '../../../lib/', __FILE__ )
$:.unshift lib unless $:.include?( lib )

require 'text_to_noise'
