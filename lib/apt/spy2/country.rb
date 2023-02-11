# frozen_string_literal: true

module Apt
  module Spy2
    # lookup a country based on code
    class Country
      def initialize(country_database)
        @database = country_database
      end

      def to_country_name(code)
        code = code.upcase
        return capitalize!(code) unless code.length == 2

        File.open(@database).each do |line|
          country, tld = line.split(';', 2)
          tld.gsub!(/\n/, '')

          return capitalize!(country) if code == tld
        end

        raise "Could not look up: #{code}"
      end

      private

      def capitalize!(str)
        str.split(' ').map(&:capitalize).join(' ')
      end
    end
  end
end
