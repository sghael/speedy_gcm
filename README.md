# THIS IS A WORK IN PROGRESS.  DO NOT USE THIS CODE YET.
# (9/30/2012)

# Speedy GCM

Speedy GCM sends push notifications to Android devices via Google's [GCM](http://developer.android.com/guide/google/gcm/index.html) (Google Cloud Messaging for Android).

Pull requests are welcome!

# How is this GEM different than other C2DM gems?

- Simple Ruby implementation.
- No dependencies.
- Implemented against the JSON based service for GCM.  If you need text/plain support look elsewhere.
- Validation of your message options.
- Tests


##Installation

    $ gem install speedy_gcm


##Requirements

An Android device running 2.2 or newer, its registration token, and a Google account registered for gcm.

Also, make sure 'net/http' and 'net/https' are available:

    require "net/http"
    require "net/https"

The 'shoulda' gem is required for testing:

    $ gem install 'shoulda'

##Compatibility

Speedy_GCM will work with Rails 3.x & Ruby 1.9x.  It has not been tested on previous versions or Rails or Ruby, and may or may not work with those versions.


##Usage

For a Rails app, a good place to put the following would be in config/initializers/speedy_gcm.rb :

    GCM_API_KEY = "YOUR API KEY"

    SpeedyGCM::API.set_account(GCM_API_KEY)

Then, where you want to make a GCM call in your code, create an message_options hash and pass it to send_notification():

    message_options = {
      :registration_ids => [<array of registration ids>],
      # optional parameters below.  Read the docs here: http://developer.android.com/guide/google/gcm/gcm.html#send-msg
      :collapse_key => "foobar",
      :data => { :score => "3x1" },
      :delay_while_idle => false,
      :time_to_live => 1
    }

    response = SpeedyGCM::API.send_notification(message_options)

    puts response[:code]  # some http response code like 200
    puts response[:data]  # usually nil is returned

Note:  there are blocking calls in both .set_account() and .send_notification().  You should use an async queue like [Sidekiq](https://github.com/mperham/sidekiq) to ensure a non-blocking code path in your application code, particularly for the .send_notification() call.


##Testing

To test, first fill out these variables in test/test_speedy_gcm.rb:

    GCM_API_KEY = "TODO - Fill in with your GCM API Key"
    TEST_PHONE_GCM_REGISTRATION_ID = "TODO - Fill in with some valid GCM Registration ID"

then run:

    $ ruby test/test_speedy_gcm.rb

##Copyrights

* See LICENSE.txt for details.