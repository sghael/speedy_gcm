require "speedy_gcm/version"

module SpeedyGCM

  class API
    PUSH_URL = 'https://android.googleapis.com/gcm/send'

    class << self

      def set_account(auth_token)
        @auth_token = auth_token
      end

      # Send a notification
      #
      # :registration_id is required.
      # :message is required.
      #
      # +options+ = {
      #   :registration_id => "...",
      #   :message => "Hi!",
      # }
      def send_notification(options)
        response = notificationRequest(options)
        return response
      end

      def notificationRequest(options)
        params ={
          :registration_ids => [
            options[:registration_id]
          ],
          :data => { 
              :message => options[:message] 
          },
          :delay_while_idle => true
        }

        data = params.as_json

        headers = { "Authorization" => "Authorization:key=#{@auth_token}",
                    "Content-type" => "application/json",
                    "Content-length" => "#{data.length}" }
        uri = URI.parse(PUSH_URL)
        http = Net::HTTP.new(uri.host, uri.port)
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        http.post(uri.path, data, headers)
      end

    end

  end
end
