require 'rubygems'
require 'bundler/setup'
require 'simplecov'
SimpleCov.start do
  add_filter "/.bundle/"
  add_filter "/bundle/"
end

Bundler.require
require 'test/unit'
