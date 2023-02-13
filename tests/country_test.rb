# frozen_string_literal: true

require_relative '../test_helper'
require_relative '../lib/apt/spy2/country'

# test the name resolution
class CountryTest < Minitest::Test
  def test_tld_to_name
    # fixtures for people who don't want to read about rails
    data = {
      'de' => 'Germany',
      'fr' => 'France',
      'IE' => 'Ireland',
      'US' => 'United States',
      'United Kingdom' => 'United Kingdom',
      'germany' => 'Germany'
    }

    c = Apt::Spy2::Country.new(File.open("#{File.dirname(File.dirname(__FILE__))}/var/country-names.txt", 'r:UTF-8'))

    data.each_pair do |code, expected|
      assert_equal(expected, c.to_country_name(code))
    end
  end
end
