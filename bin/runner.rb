begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

gemfile(true) do
  source "https://rubygems.org"

  gem "prog-channels", path: "."
end

require "minitest/autorun"
require_relative "../lib/prog/channels"

@slack_client     = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
Airrecord.api_key = ENV['AIRTABLE_KEY']

# TODO, Run me daily:
Prog::Channels::Syncopator.new(slack_client: @slack_client, table: Prog::Channels::ChannelList).call
