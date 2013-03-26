# encoding: utf-8

require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end
require 'rake'
require "hoe"

# Hoe.plugin :compiler
# Hoe.plugin :gem_prelude_sucks
# Hoe.plugin :inline
# Hoe.plugin :racc
# Hoe.plugin :rcov
# Hoe.plugin :rubyforge

Hoe.spec "geti" do
  # require 'jeweler'
  # Jeweler::Tasks.new do |gem|
  #   # gem is a Gem::Specification... see http://docs.rubygems.org/read/chapter/20 for more options
  #   gem.name = "geti"
  #   gem.homepage = "http://github.com/jamie/geti"
  #   gem.license = "MIT"
  #   gem.summary = %Q{API wrapper for GETI, an ACH provider}
  #   gem.description = %Q{API wrapper for GETI, an ACH provider}
  #   gem.files.exclude "doc/*.pdf"
  #   # dependencies defined in Gemfile
  # end
  # Jeweler::RubygemsDotOrgTasks.new


  developer("Jamie Macey", "jamie@tracefunc.com")
  license "MIT"
end

require 'rcov/rcovtask'
Rcov::RcovTask.new do |test|
  test.libs << 'test'
  test.pattern = 'test/**/test_*.rb'
  test.verbose = true
  test.rcov_opts << '--exclude "gems/*"'
end

task :default => :spec

require 'rdoc/task'
Rake::RDocTask.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "geti #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
