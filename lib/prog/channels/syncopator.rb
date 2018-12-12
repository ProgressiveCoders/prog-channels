require 'pay_dirt'

module Prog
  module Channels
    class Syncopator < PayDirt::Base
      def initialize(options = {})
        load_options(:table, :slack_client, options) do # after loading options
          # Validate Airtable / Airrecord
          raise unless @table.ancestors.include?(Airrecord::Table)

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
              channel_details = @slack_client.channels_info(channel: channel[:id]).channel

              new_channel = @table.new({
                "Channel Name"     => channel[:name],
                "Creation Date"    => Time.at(channel[:created]).strftime("%m/%d/%Y"),
                "Membership"       => channel[:num_members].to_s,
                "Status"           => channel[:is_archived] ? "Archived" : "Active",
                "Channel Purpose"  => channel[:purpose][:value],
                "Last Activity"    => Time.at((channel_details&.latest&.ts || channel_details&.last_read).to_f).strftime("%m/%d/%Y"),
                "Channel Topic"    => channel_details.topic.value,
              })

              new_channel.create
            when 1
              # update existing record
              channel_details = @slack_client.channels_info(channel: channel[:id]).channel

              existing_channel = @table.find(matches[0].id)
              existing_channel["Channel Name"]     = channel[:name]
              existing_channel["Creation Date"]    = Time.at(channel[:created]).strftime("%m/%d/%Y")
              existing_channel["Membership"]       = channel[:num_members].to_s
              existing_channel["Channel Purpose"]  = channel[:purpose][:value]
              existing_channel["Status"]           = "Archived" if channel[:is_archived]
              existing_channel["Last Activity"]    = Time.at((channel_details&.latest&.ts || channel_details&.last_read).to_f).strftime("%m/%d/%Y")
              existing_channel["Channel Topic"]    = channel_details.topic.value

              existing_channel.save
            else
              # just warn?
            end
          end
        end
    end
  end
end
