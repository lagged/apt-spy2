require 'colored'
require 'json'

module Apt
  module Spy2
    class Writer
      def initialize(format)

        if !["json", "shell"].include?(format)
          raise "Unknown format: #{format}"
        end

        @format = format
        @complete = []
      end

      def set_complete(complete)
        @complete = complete
      end

      def echo(data)
        if @format == 'json'
          @complete.push(data)
          return
        end

        print "Mirror: #{data["mirror"]} - "

        case data["status"]
        when "up"
          puts data["status"].upcase.green
        when "down"
          puts data["status"].upcase.red
        when "broken"
          puts data["status"].upcase.yellow
        else
          puts "Unknown status: #{data["status"]}".white_on_red
        end
      end

      def json?
        if @format == 'json'
          return true
        end

        return false
      end

      def to_json
        JSON.generate(@complete)
      end

    end
  end
end
