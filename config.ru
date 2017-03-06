# frozen_string_literal: true

require 'bundler/setup'

$LOAD_PATH.unshift File.expand_path('./lib', File.dirname(__FILE__))
require 'server'
run Server
