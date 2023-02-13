# frozen_string_literal: true

require 'colored'
require 'json'
require 'apt/spy2/status'

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
        Apt::Spy2::Status.print(data['status'])
      end

      def json?
        return true if @format == 'json'

        false
      end

      # generates a json string
      def to_json(*_args)
        JSON.generate(@complete)
      end
    end
  end
end
