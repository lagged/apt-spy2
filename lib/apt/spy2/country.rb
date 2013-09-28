module Apt
  module Spy2
    class Country

      def initialize(country_database)
        @database = country_database
      end

      def to_country_name(code)
        code = code.upcase
        return capitalize(code) unless code.length == 2

        File.open(@database).each do |line|
          country, tld = line.split(';', 2)
          tld.gsub!(/\n/, '')

          if code == tld
            return capitalize(country)
          end

        end

        raise "Could not look up: #{code}"
      end

      private
      def capitalize(str)
        return str.split(" ").map(&:capitalize).join(" ")
      end

    end
  end
end
