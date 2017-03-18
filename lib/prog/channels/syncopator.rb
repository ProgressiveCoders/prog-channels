require 'pay_dirt'

module Prog
  module Channels
    class Syncopator < PayDirt::Base
      def initialize(options = {})
        load_options(:table, :slack_client, options) do # after loading options
          # Validate Airtable / Airrecord
          raise unless @table.kind_of?(Airrecord::Table)

          # Validate Slack Client
          raise unless @slack_client.is_a?(Slack::Web::Client)
          raise unless @slack_client.auth_test.ok
        end
      end

      def call
        syncopate

        return result(true, nil)
      end

      private

        def syncopate
          @slack_client.channels_list.channels.each do |channel|
            match = @table.all({filter: "{Channel Name} = \"#{channel[:name]}\""})

            case match.length
            when 0
              # create new record
            when 1
              # update existing record
            else
              # just warn?
            end
          end
        end
    end
  end
end
