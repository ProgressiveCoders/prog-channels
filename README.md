# Prog::Channels

[![Code Climate](https://codeclimate.com/github/ProgressiveCoders/prog-channels/badges/gpa.svg)](https://codeclimate.com/github/ProgressiveCoders/prog-channels)

This repo includes a ruby gem providing an empty `Prog::Channels` class. The only code written so far is in `credentials_test.rb`

## Usage

Copy `.env.example` to `.env` then run `ruby credentials_test.rb`. The tests therein should fail unless the `.env` file has true credentials.

To run unit tests (these don't touch Slack or Airtable, they run against mocks):

    rake test

## Dependencies

- ["airrecord"](https://github.com/sirupsen/airrecord)
- ["slack-ruby-client"](https://github.com/slack-ruby/slack-ruby-client)

Using airrecord because the airtable/airtable gem has some glaring issues at this time.

## Development

The `credentials_test.rb` file shows the general direction this effort is heading in.
Essentially: use the slack gem to get channel lists and info, then use the airtable gem (airrecord) to update the Airtable document with latest info.

Next steps: add a private method to Prog::Channels::Syncopator that loops over slack info,
updating or creating records in Airtable.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ProgressiveCoders/prog-channels.
