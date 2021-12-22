require "bundler/gem_tasks"
require "minitest/autorun"
require "simplecov"
require "simplecov-lcov"

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

task :test do
  ENV['COVERAGE'] = 'true'

  SimpleCov.formatter = SimpleCov::Formatter::LcovFormatter
  SimpleCov::Formatter::LcovFormatter.config do |c|
    c.output_directory = './coverage'
    c.report_with_single_file = true
    c.single_report_path = './coverage/lcov.info'
  end
  SimpleCov.start

  $LOAD_PATH.unshift('lib', 'tests')
  Dir.glob('./tests/*_test.rb') do |f|
    require f
  end
end
