# Prog::Channels

[![Code Climate](https://codeclimate.com/github/ProgressiveCoders/prog-channels/badges/gpa.svg)](https://codeclimate.com/github/ProgressiveCoders/prog-channels)

## Usage

Copy `.env.example` to `.env` and ensure you update it with real credentials.

Next run `bundle exec rake test` to ensure all systems are go.

Finally, `bin/sync` oughta do something fun with slack and airtable.

There's also a rake task that will simply run `bin/sync`:

    rake prog:channels:sync

## Testing

Integration tests essentially check that the tokens for Slack and for Airtable are set and are valid.

Unit tests run against mocks and don't touch either API.

    bundle exec rake test

## Dependencies

- ["airrecord"](https://github.com/sirupsen/airrecord)
- ["slack-ruby-client"](https://github.com/slack-ruby/slack-ruby-client)

## Development

First Goal: use the slack gem to get channel lists and info, then use the airtable gem (airrecord) to update the Airtable document with latest info. :check:

Next Goals: clean it up; document or automate deployment steps; automate build; release a rubygem(?); have fun :)

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ProgressiveCoders/prog-channels.
