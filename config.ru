# -*- mode: ruby; tab-width: 2; indent-tabs-mode: nil -*-
# vim: ts=4 sw=2 ft=ruby et

# Set up gems listed in the Gemfile.
ENV['BUNDLE_GEMFILE'] ||= File.expand_path('../Gemfile', __FILE__)

require 'bundler/setup' if File.exist?(ENV['BUNDLE_GEMFILE'])
require 'rubygems'
require File.expand_path('../app.rb', __FILE__)

run RedactorUploadCrossDomain
