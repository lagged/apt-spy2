# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../lib/apt/spy2/status'

# test the name resolution
class StatusTest < Minitest::Test
  def test_response_code_to_status
    data = {
      '200' => Apt::Spy2::Status::UP,
      '404' => Apt::Spy2::Status::BROKEN,
      '500' => Apt::Spy2::Status::DOWN,
      '' => Apt::Spy2::Status::DOWN
    }

    data.each_pair do |code, expected|
      status = Apt::Spy2::Status.status?(code)
      assert_equal(expected, status)
    end
  end
end
