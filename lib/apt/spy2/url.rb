# frozen_string_literal: true

module Apt
  module Spy2
    # build mirror url
    class Url
      def initialize(strict)
        @strict = strict
      end

      def adjust!(mirror)
        return mirror unless @strict

        "#{mirror}dists/#{release}/Contents-#{arch}.gz"
      end

      private

      def arch
        `dpkg --print-architecture`.strip
      end

      def release
        `lsb_release -c`.split(' ')[1].strip
      end
    end
  end
end
