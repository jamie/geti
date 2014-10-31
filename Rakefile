# encoding: utf-8

require 'rubygems'
require 'bundler/setup'
require "hoe"

Hoe.plugin :bundler
Hoe.plugin :git
Hoe.spec "geti" do
  developer("Jamie Macey", "jamie@tracefunc.com")
  license "MIT"

  dependency 'savon', "~> 2.0"
  dependency 'httpi', ">0"
  dependency 'httpclient', ">0"
  dependency 'nokogiri', "<1.6" # Ruby 1.8 compatible

  # Development
  dependency 'rake', "< 0.9", :dev
  dependency 'bundler', '>0', :dev
  dependency "hoe", '>0', :dev
  dependency "hoe-bundler", '>0', :dev
  dependency "hoe-git", '>0', :dev

  # Test
  dependency "rcov", '>0', :dev
  dependency 'rspec', '>0', :dev
  dependency 'guard', '>0', :dev
  dependency 'guard-rspec', '>0', :dev
  dependency 'rb-fsevent', '~> 0.9.1', :dev
end
