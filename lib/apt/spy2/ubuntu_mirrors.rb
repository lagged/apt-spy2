require 'open-uri'

module Apt
  module Spy2
    class UbuntuMirrors

      def initialize(url)
        @ubuntu_mirrors = url
      end

      def get_mirrors(country)

        begin
          country.upcase! if country.length == 2
          mirrors = open("#{@ubuntu_mirrors}/#{country}.txt") do |list|
            list.read
          end
        rescue OpenURI::HTTPError => the_error
          case the_error.io.status[0]
            when "404"
              raise "The country code '#{country}' is incorrect."
            else
              raise "Status: #{the_error.io.status[0]}"
          end
        end

        mirrors = mirrors.split(/\n/)
        return mirrors

      end

    end
  end
end
