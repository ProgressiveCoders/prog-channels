require 'pay_dirt'

module Prog
  module Channels
    class Syncopator < PayDirt::Base
      def initialize(options = {})
        # sets instance variables from key value pairs,
        # will fail if any keys given before options aren't in options
        load_options(:table, :slack_client, options) do # after loading options
          # Validate Airtable / Airrecord
          raise unless @table.kind_of?(Airrecord::Table)

          # Validate Slack Client
          raise unless @slack_client.is_a?(Slack::Web::Client)
          raise unless @slack_client.auth_test.ok
        end
      end

      def call
        return result(true, nil)
      end
    end
  end
end
