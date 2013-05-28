require "speedy_gcm/version"

module SpeedyGCM

  # message_options
  #
  # :registration_ids
  #   A string array with the list of devices (registration IDs) receiving the message. It must contain at least 1 and at most 1000 registration IDs. To send a multicast message, you must use JSON. For sending a single message to a single device, you could use a JSON object with just 1 registration id, or plain text (see below). Required.
  #
  # :collapse_key
  #   An arbitrary string (such as "Updates Available") that is used to collapse a group of like messages when the device is offline, so that only the last message gets sent to the client. This is intended to avoid sending too many messages to the phone when it comes back online. Note that since there is no guarantee of the order in which messages get sent, the "last" message may not actually be the last message sent by the application server. See Advanced Topics for more discussion of this topic. Optional, unless you are using the time_to_live parameter—in that case, you must also specify a collapse_key.
  #
  # :data
  #   A JSON object whose fields represents the key-value pairs of the message's payload data. If present, the payload data it will be included in the Intent as application data, with the key being the extra's name. For instance, "data":{"score":"3x1"} would result in an intent extra named score whose value is the string 3x1. There is no limit on the number of key/value pairs, though there is a limit on the total size of the message (4kb). The values could be any JSON object, but we recommend using strings, since the values will be converted to strings in the GCM server anyway. If you want to include objects or other non-string data types (such as integers or booleans), you have to do the conversion to string yourself. Also note that the key cannot be a reserved word (from or any word starting with google.). To complicate things slightly, there are some reserved words (such as collapse_key) that are technically allowed in payload data. However, if the request also contains the word, the value in the request will overwrite the value in the payload data. Hence using words that are defined as field names in this table is not recommended, even in cases where they are technically allowed. Optional.
  #
  # :delay_while_idle
  #   If included, indicates that the message should not be sent immediately if the device is idle. The server will wait for the device to become active, and then only the last message for each collapse_key value will be sent. Optional. The default value is false, and must be a JSON boolean.
  #
  # :time_to_live
  #   How long (in seconds) the message should be kept on GCM storage if the device is offline. Optional (default time-to-live is 4 weeks, and must be set as a JSON number). If you use this parameter, you must also specify a collapse_key.

  class API
    PUSH_URL = 'https://android.googleapis.com/gcm/send'

    class << self

      def set_account(api_key)
        @api_key = api_key
      end

      def send_notification(message_opts)
        headers = { "Content-Type" => "application/json",
                    "Authorization" => "key=#{@api_key}" }

        # symbolize all keys
        message_opts = symbolize_keys(message_opts)

        # validate the message options
        message_validation(message_opts)

        url = URI.parse PUSH_URL
        http = Net::HTTP.new(url.host, url.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        resp, dat = http.post(url.path, message_opts.to_json, headers)

        return {:code => resp.code.to_i, :message => dat }
      end

      private

      def symbolize_keys(myhash)
        myhash.keys.each do |key|
          myhash[(key.to_sym rescue key) || key] = myhash.delete(key)
        end
        return myhash
      end

      def message_validation(message_opts)
        # check if message_opts has required info
        raise ArgumentError, "registration_ids is a required param of the GCM message" unless message_opts.has_key? :registration_ids

        # if you use the delay_while_idle is an included parameter, it must be a boolean
        if message_opts.has_key? :delay_while_idle
          raise ArgumentError, "if you include the delay_while_idle parameter, it must be a boolean" unless ( [true, false].include? message_opts[:delay_while_idle])
        end

        # if you use the time_to_live parameter, you must also include a collapse_key
        if (message_opts.has_key? :time_to_live) and (!message_opts.has_key? :collapse_key)
          raise ArgumentError, "if you use the time_to_live parameter, you must also include a collapse_key"
        end

        # if you use the time_to_live parameter, it should be an integer
        if message_opts.has_key? :time_to_live
          raise ArgumentError, "if you use the time_to_live parameter, it should be an integer" unless (message_opts[:time_to_live].is_a? Integer)
        end

        # registration_ids must contain at least 1 and at most 1000 registration IDs
        registration_ids = message_opts[:registration_ids]

        if (registration_ids.length < 1) or (registration_ids.length > 1000)
          raise ArgumentError, "registration_ids must contain at least 1 and at most 1000 registration IDs"
        end

        message_opts_json = message_opts.except(:registration_ids).to_json

        if (message_opts_json.to_s.bytesize > 4096)
          # data must be less than 4kb in length
          raise StandardError, "the size of the message is over 4kb"
        end
      end

    end

  end
end
