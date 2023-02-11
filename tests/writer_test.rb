# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../lib/apt/spy2/writer'
require 'json'

# test to check request lib
class WriterTest < Minitest::Test
  def test_json
    fixture = { 'mirror': 'http://example.org', 'status': 'up' }

    w = Apt::Spy2::Writer.new('json')
    w.echo(fixture)

    # json string
    j = w.to_json

    assert_equal(true, w.json?)
    assert_equal(true, j.is_a?(String))
    assert_equal(true, JSON.parse(j).is_a?(Array))
  end

  def test_no_json
    w = Apt::Spy2::Writer.new('shell')
    assert_equal(false, w.json?)
  end
end
