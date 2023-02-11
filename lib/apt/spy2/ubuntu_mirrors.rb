# frozen_string_literal: true

module Apt
  module Spy2
    # wraps around the \n delimited list of mirrors
    class UbuntuMirrors
      def initialize(download)
        @ubuntu_mirrors = download
      end

      def mirrors(_country)
        mirrors = @ubuntu_mirrors
        mirrors.split(/\n/)
      end
    end
  end
end
