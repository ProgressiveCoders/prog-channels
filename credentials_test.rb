begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

gemfile(true) do
  source "https://rubygems.org"
  gem "dotenv"
  gem "pry"

  gem "prog-channels", path: "."
end

require "dotenv/load"
require "minitest/autorun"
require "slack"
require "airrecord"

class ChannelList < Airrecord::Table
  self.base_key   = ENV['AIRTABLE_APP']
  self.table_name = "Channel List"
end


class CredentialsTest < Minitest::Test
  def setup
    @slack_client = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
    Airrecord.api_key = ENV['AIRTABLE_KEY']
  end

  def test_stuff
    assert_slack
    assert_airtable
  end

  def assert_slack
    assert @slack_client.auth_test.ok = true

    assert_equal %w{
      created
      creator
      id
      is_archived
      is_channel
      is_general
      is_member
      members
      name
      name_normalized
      num_members
      previous_names
      purpose
      topic
    }, @slack_client.channels_list.channels[0].keys.sort
  end

  def assert_airtable
    assert ChannelList.records.count >= 1
    refute_empty ChannelList.all(filter: '{Channel Name} = "thanks"')
  end
end
