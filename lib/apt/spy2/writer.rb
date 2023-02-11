# frozen_string_literal: true

require 'colored'
require 'json'

module Apt
  module Spy2
    # abstracted puts or json
    class Writer
      def initialize(format)
        raise "Unknown format: #{format}" unless %w[json shell].include?(format)

        @format = format
        @complete = []
      end

      def complete(complete)
        @complete = complete
      end

      def echo(data)
        if @format == 'json'
          @complete.push(data)
          return
        end

        print "Mirror: #{data['mirror']} - "

        case data['status']
        when 'up'
          puts data['status'].upcase.green
        when 'down'
          puts data['status'].upcase.red
        when 'broken'
          puts data['status'].upcase.yellow
        else
          puts "Unknown status: #{data['status']}".white_on_red
        end
      end

      def json?
        return true if @format == 'json'

        false
      end

      def to_json(*_args)
        JSON.generate(@complete)
      end
    end
  end
end
