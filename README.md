# Prog::Channels

[![Code Climate](https://codeclimate.com/github/ProgressiveCoders/prog-channels/badges/gpa.svg)](https://codeclimate.com/github/ProgressiveCoders/prog-channels) [![Build Status](https://travis-ci.org/rthbound/prog-channels.svg?branch=master)](https://travis-ci.org/rthbound/prog-channels)

## Usage

Copy `.env.example` to `.env` and ensure you update it with real credentials.

Next run `bundle exec rake test` to ensure all systems are go.

Finally, `bin/sync` oughta do something fun with slack and airtable.

There's also a rake task that will simply run `bin/sync`:

    rake prog:channels:sync

**Note:** Check out the comments in [`.env.example`](.env.example) for
details on where to get each credential for configuration.

## Testing

Integration tests essentially check that the tokens for Slack and for Airtable are set and are valid.

Unit tests run against mocks and don't touch either API.

    bundle exec rake test

## Dependencies

- ["airrecord"](https://github.com/sirupsen/airrecord)
- ["slack-ruby-client"](https://github.com/slack-ruby/slack-ruby-client)

## Development

First Goal: use the slack gem to get channel lists and info, then use the airtable gem (airrecord) to update the Airtable document with latest info. :check:

Next Goals: clean it up; automate build; release a rubygem(?); have fun :)

## Deployment

Heroku:

    git clone git@github.com:ProgressiveCoders/prog-channels.git
    heroku create
    git push heroku master
    heroku ps:scale web=1
    heroku addons:create scheduler:standard


Next run `heroku addons:open scheduler` to configure the scheduler addon to run the following task as often as you like:

    rake prog:channels:sync

And set environment variables:

    heroku config:set SLACK_API_TOKEN=xoxp-the-real-one \
                      AIRTABLE_KEY=keyTherealone        \
                      AIRTABLE_APP=appSomeRealOne       \
                      AIRTABLE_BASE="Real Table Name"   \

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ProgressiveCoders/prog-channels.
