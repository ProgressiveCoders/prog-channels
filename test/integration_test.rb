begin
  require "bundler/inline"
rescue LoadError => e
  $stderr.puts "Bundler version 1.10 or later is required. Please update your Bundler"
  raise e
end

gemfile(true) do
  source "https://rubygems.org"

  gem "prog-channels", path: ".."
end

require "minitest/autorun"
require_relative "../lib/prog/channels"

class CredentialsTest < Minitest::Test
  def setup
    @slack_client     = Slack::Web::Client.new(token: ENV['SLACK_API_TOKEN'])
    Airrecord.api_key = ENV['AIRTABLE_KEY']
  end

  def test_slack
    assert_equal true, @slack_client.auth_test.ok
  end

  def test_airtable
    assert Prog::Channels::ChannelList.records.count >= 1
  end
end
