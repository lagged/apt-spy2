# frozen_string_literal: true

require 'simplecov'
require 'simplecov-lcov'

if ENV['CI']
  SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.output_directory = './coverage'
    c.report_with_single_file = true
    c.single_report_path = './coverage/lcov.info'
  end
else
  SimpleCov.formatter SimpleCov::Formatter::MultiFormatter.new([
                                                                 SimpleCov::Formatter::SimpleFormatter,
                                                                 SimpleCov::Formatter::HTMLFormatter
                                                               ])
end

SimpleCov.profiles.define 'apt-spy2' do
  add_filter '/tests/'
  add_filter '/pkg/'
  add_filter '/vendor/'
  add_filter '/var'

  add_group 'lib', 'lib/apt'
  add_group 'bin', 'bin'
end
SimpleCov.start 'apt-spy2'
require 'minitest/autorun'
