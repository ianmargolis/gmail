require 'gmail_xoauth'

module Gmail
  module Client
    class XOAuth2 < Base
      attr_reader :oauth2_token

      def initialize(username, options={})
        @oauth2_token = options.delete(:oauth2_token)
        super(username, options)
      end

      def login(raise_errors=false)
        @imap and @logged_in = (login = @imap.authenticate('XOAUTH2', username, oauth2_token)) && login.name == 'OK'
      rescue
        raise_errors and raise AuthorizationError, "Couldn't login to given GMail account: #{username}"
      end

      # TODO: Update this for xoauth2
      # https://github.com/nfo/gmail_xoauth/blob/master/lib/gmail_xoauth/smtp_xoauth2_authenticator.rb
      def smtp_settings
        [:smtp, {
           :address => GMAIL_SMTP_HOST,
           :port => GMAIL_SMTP_PORT,
           :domain => mail_domain,
           :user_name => username,
           :password => {
             :consumer_key    => consumer_key,
             :consumer_secret => consumer_secret,
             :token           => token,
             :token_secret    => secret
           },
           :authentication => :xoauth,
           :enable_starttls_auto => true
         }]
      end
    end # XOAuth

    register :xoauth2, XOAuth2
  end # Client
end # Gmail
