# encoding: UTF-8

require 'rubygems'
require 'bundler'
Bundler.setup(:default, :test)
Bundler.require(:default, :test)

require 'rspec'
require 'fluent/test'

$TESTING=true
$:.unshift File.join(File.dirname(__FILE__), '..', 'lib')
require 'fluent/plugin/out_ses'

