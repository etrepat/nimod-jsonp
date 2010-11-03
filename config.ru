require 'rubygems'
require 'bundler'

Bundler.require

require File.dirname(__FILE__) + '/service.rb'
run Sinatra::Application

