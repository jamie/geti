require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development, :test)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'rspec'
require 'rspec/mocks'
require 'ostruct'
class OpenStruct
  def inspect
    "<OpenStruct \"#{@table.inspect}\">"
  end
end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'pp'
require 'geti'


Savon.configure do |config|
  config.log = HTTPI.log = false unless ENV['SOAP_DEBUG']
end

def test_credentials
  YAML.load(File.read('config/test_credentials.yml'))
end

def xit(*args, &block)
  # noop, disabled spec.
end
