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

# require 'vcr'
# VCR.configure do |config|
#   config.cassette_library_dir = "spec/fixtures/vcr_cassettes"
#   config.hook_into :webmock
#   config.configure_rspec_metadata!
# end

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'pp'
require 'geti'

def test_credentials(env='app')
  YAML.load(File.read('config/test_credentials.yml'))[env]
end

def fixture(name)
  File.read(File.expand_path("./spec/fixtures/#{name}.xml"))
end

def xit(*args, &block)
  # noop, disabled spec.
end
