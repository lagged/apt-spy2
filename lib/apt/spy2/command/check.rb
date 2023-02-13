# frozen_string_literal: true

require 'apt/spy2/command/command'
require 'apt/spy2/writer'

module Apt
  module Spy2
    module Command
      # runs `apt-spy2 check`
      class Check < BaseCommand
        option :output, type: :boolean, default: true
        option :format, default: 'shell'
        option :strict, type: :boolean

        desc 'do_it', ''
        def do_it
          @writer = Apt::Spy2::Writer.new(options[:format])

          mirrors = retrieve(launchpad: use_launchpad?(options))
          filter(mirrors, strict: options[:strict], output: options[:output])

          puts @writer.to_json if @writer.json?
        end

        default_task :do_it
      end
    end
  end
end
