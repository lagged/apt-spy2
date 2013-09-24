require 'apt/spy2/country'

class CountryTest < Minitest::Test
  def setup
    @country_list = File.expand_path(File.dirname(__FILE__) + "/../var/country-names.txt")
  end

  def test_tld_to_name()


    data = {
      'de' => 'Germany',
      'fr' => 'France',
      'IE' => 'Ireland',
      'US' => 'United States'
    }

    c = Apt::Spy2::Country.new(@country_list)

    data.each_pair do |code, expected|
      assert_equal(expected, c.to_country_name(code))
    end

  end
end
