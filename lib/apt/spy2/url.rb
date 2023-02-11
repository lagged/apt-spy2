module Apt
  module Spy2
    class Url
      def initialize(strict)
        @strict = strict
      end

      def get_mirror(mirror)
        return mirror unless @strict

        return "#{mirror}dists/#{get_release()}/Contents-#{get_arch()}.gz"
      end

      private
      def get_arch()
        return `dpkg --print-architecture`.strip
      end

      private
      def get_release()
        return `lsb_release -c`.split(" ")[1].strip
      end
    end
  end
end
