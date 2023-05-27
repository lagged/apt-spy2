# frozen_string_literal: true

require 'apt/spy2/command/command'
require 'apt/spy2/writer'

module Apt
  module Spy2
    module Command
      # runs `apt-spy2 list`
      class List < BaseCommand
        option :format, default: 'shell'
        desc 'do_it', 'run'
        def do_it
          mirrors = retrieve(launchpad: use_launchpad?(options))

          @writer = Apt::Spy2::Writer.new(options[:format])
          @writer.complete(mirrors)

          if @writer.json?
            puts @writer.to_json
            return
          end

          puts mirrors
        end

        default_task :do_it
      end
    end
  end
end
