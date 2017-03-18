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
            matches = @table.all({filter: "{Channel Name} = \"#{channel[:name]}\""})

            case matches.length
            when 0
              # create new record

              new_channel = @table.new({
                "ZChannel Name"     => channel[:name],
                "ZCreation Date"     => Time.at(channel[:created]).strftime("%m/%d/%Y"),
                "ZMembership Range" => channel[:num_members],
                "ZChannel Type"     => "New",
                "ZStatus"           => "Active",
              })

              new_channel.create
            when 1
              # update existing record

              existing_channel = @table.find(matches[0].id)
              existing_channel["ZChannel Name"]     = channel[:name]
              existing_channel["ZCreation Date"]    = Time.at(channel[:created]).strftime("%m/%d/%Y")
              existing_channel["ZMembership Range"] = channel[:num_members]
              existing_channel["ZStatus"]           = "Archived" if channel[:is_archived]
            else
              # just warn?
            end
          end
        end
    end
  end
end
