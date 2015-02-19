require './test/test_helper'

module TrafficSpy
  class ReferralTest < MiniTest::Test
    def teardown
      DatabaseCleaner.clean
    end

    def test_can_create_referral_entry
      referral = Referral.new(referredBy: "http://www.jumpstartlabs.com")
      assert referral.valid?
    end

    def test_will_not_create_a_duplicate_referral
      Referral.find_or_create_by(referredBy: "http://www.jumpstartlabs.com")
      Referral.find_or_create_by(referredBy: "http://www.jumpstartlabs.com")
      assert_equal 1, Referral.count
    end

    def test_creates_multiple_urls
      Referral.find_or_create_by(referredBy: "http://www.jumpstartlabs.com")
      Referral.find_or_create_by(referredBy: "http://www.google.com")
      assert_equal 2, Referral.count
    end
  end
end
