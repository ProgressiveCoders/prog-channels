# Prog::Channels

This repo includes a ruby gem providing an empty `Prog::Channels` class. The only code written so far is in `credentials_test.rb`

## Usage

Copy `.env.example` to `.env` then run `ruby credentials_test.rb`. The tests therein should fail unless the `.env` file has true credentials.

## Development

The `credentials_test.rb` file shows the general direction this effort is heading in. Essentially: use the slack gem to get channel lists and info,
then use the airtable gem (airrecord) to update the Airtable document with latest info.

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/ProgressiveCoders/prog-channels.
