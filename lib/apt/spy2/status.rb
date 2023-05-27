# frozen_string_literal: true

module Apt
  module Spy2
    # wraps up, down and broken
    class Status
      UP = 'UP'
      DOWN = 'DOWN'
      BROKEN = 'BROKEN'

      def self.print(status)
        table = { UP => 'green', DOWN => 'red', BROKEN => 'yellow' }
        puts status.send(table[status])
      end

      def self.status?(code)
        return UP if code == '200'
        return BROKEN if code == '404'

        DOWN
      end
    end
  end
end
