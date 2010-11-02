require 'rubygems'
require 'bundler'

Bundler.require

require File.dirname(__FILE__) + '/nimod.rb'
run Sinatra::Application
