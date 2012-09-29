current_dir = File.expand_path(File.dirname(__FILE__))
require File.join(current_dir, 'helper')

class TestSpeedyGCM < Test::Unit::TestCase

  API_KEY = "TODO - Fill me"
  TEST_PHONE_GCM_REGISTRATION_ID = "TODO - Fill me"

  should "not raise an error if the API key is valid" do
    assert_nothing_raised do
      SpeedyGCM::API.set_account(API_KEY)
    end
  end

  should "raise an error if the api key is not provided" do
    assert_raise(ArgumentError) do
      SpeedyGCM::API.set_account()
    end
  end

  should "not raise an error if a send notification call succeeds" do
    assert_nothing_raised do
      SpeedyGCM::API.set_account(API_KEY)

      options = {
        :registration_id => TEST_PHONE_C2DM_REGISTRATION_ID,
        :message => "Hi!"
      }

      response = SpeedyGCM::API.send_notification(options)
    end
  end

end