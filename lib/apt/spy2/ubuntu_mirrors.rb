module Apt
  module Spy2
    class UbuntuMirrors

      def initialize(download)
        @ubuntu_mirrors = download
      end

      def get_mirrors(country)

        begin
          mirrors = @ubuntu_mirrors.read
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
