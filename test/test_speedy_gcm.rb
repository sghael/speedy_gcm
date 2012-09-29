current_dir = File.expand_path(File.dirname(__FILE__))
require File.join(current_dir, 'helper')

class TestSpeedyGCM < Test::Unit::TestCase

  API_ACCOUNT_EMAIL = "TODO - Fill me"
  API_ACCOUNT_PASSWORD = "TODO - Fill me"
  TEST_PHONE_GCM_REGISTRATION_ID = "TODO - Fill me"

  should "not raise an error if the API key is valid" do
    assert_nothing_raised do
      SpeedyGCM::API.set_account(API_ACCOUNT_EMAIL, API_ACCOUNT_PASSWORD)
    end
  end

  should "raise an error if the email/password is not provided" do
    assert_raise(ArgumentError) do
      SpeedyGCM::API.set_account()
    end
  end

  should "not raise an error if a send notification call succeeds" do
    assert_nothing_raised do
      SpeedyGCM::API.set_account(API_ACCOUNT_EMAIL, API_ACCOUNT_PASSWORD)

      options = {
        :registration_id => TEST_PHONE_C2DM_REGISTRATION_ID,
        :message => "Hi!",
        :extra_data => 42,
        :collapse_key => "some-collapse-key"
      }

      response = SpeedyGCM::API.send_notification(options)
    end
  end

end