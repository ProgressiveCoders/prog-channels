class Prog::Channels::ChannelList < Airrecord::Table
  self.base_key   = ENV['AIRTABLE_APP']
  self.table_name = "Channel List"
end
