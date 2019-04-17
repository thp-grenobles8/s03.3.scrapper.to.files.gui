require 'bundler'
Bundler.require

require 'open-uri'

$:.unshift File.expand_path("./../lib", __FILE__)

require 'app/file_writer'
require 'app/scrapper'
require 'views/index'
require 'views/done'


Index.new.perform
