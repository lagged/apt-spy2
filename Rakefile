# frozen_string_literal: true

require 'bundler/gem_tasks'
require 'rake/testtask'

Encoding.default_external = Encoding::UTF_8
Encoding.default_internal = Encoding::UTF_8

Rake::TestTask.new do |t|
  ENV['COVERAGE'] = 'true'
  t.pattern = 'tests/*_test.rb'

  # $LOAD_PATH.unshift('lib', 'tests')
  # Dir.glob('./tests/*_test.rb').sort.each do |f|
  #   require f
  # end
end
