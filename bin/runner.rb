require_relative "../lib/prog/channels"

@slack_client     = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
Airrecord.api_key = ENV['AIRTABLE_KEY']

Prog::Channels::Syncopator.new(slack_client: @slack_client, table: Prog::Channels::ChannelList).call
