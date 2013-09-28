module Apt
  module Spy2
    class UbuntuMirrors

      def initialize(download)
        @ubuntu_mirrors = download
      end

      def get_mirrors(country)

        mirrors = @ubuntu_mirrors
        mirrors = mirrors.split(/\n/)
        return mirrors

      end

    end
  end
end
