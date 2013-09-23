require "bundler/gem_tasks"
require 'minitest/autorun'

task :test do
  $LOAD_PATH.unshift('lib', 'tests')
  Dir.glob('./tests/*_test.rb') do |f|
    require f
  end
end
