require 'test_helper'

describe Prog::Channels::Syncopator do
  before do
    @subject = Prog::Channels::Syncopator
    @params = {
      table:        MiniTest::Mock.new,
      slack_client: MiniTest::Mock.new,
    }

    # Airtable expectations
    @params[:table].expect(:ancestors, [Airrecord::Table], [])

    # Slack client expectations
    @params[:slack_client].expect(:is_a?, true, [Slack::Web::Client])
    @params[:slack_client].expect(:auth_test, @auth_test = MiniTest::Mock.new, [])
    @auth_test.expect(:ok, true, [])

    @params[:slack_client].expect(:channels_list, @slack_channel_list = MiniTest::Mock.new, [])
    @slack_channel_list.expect(:channels, [@slack_channel_list_item = MiniTest::Mock.new], [])
    @slack_channel_list_item.expect(:[], "thanks", [:name])
  end

  describe "as a class" do
    it "initializes properly" do
      @subject.new(@params).must_respond_to :call
    end

    it "errors when initialized without required dependencies" do
      -> { @subject.new(@params.reject { |k| k.to_s == 'table' }) }.must_raise RuntimeError
      -> { @subject.new(@params.reject { |k| k.to_s == 'slack_client' }) }.must_raise RuntimeError
    end
  end

  describe "when updating" do
    it "executes successfully when updating" do
      @params[:table].expect(:all, [@airtable_match = MiniTest::Mock.new], [{filter: '{Channel Name} = "thanks"'}])
      @slack_channel_list_item.expect(:[], "123456789", [:id])
      @params[:slack_client].expect(:channels_info, @channel_info = MiniTest::Mock.new, [{channel: "123456789"}])
      @channel_info.expect(:channel, @channel = MiniTest::Mock.new)
      @airtable_match.expect(:id, "rec123")
      @params[:table].expect(:find, @existing_record = MiniTest::Mock.new, ["rec123"])

      time    = Time.now
      purpose = "To rage aginst the dying of the light"

      @slack_channel_list_item.expect(:[], "thanks", [:name])
      @existing_record.expect(:[]=, "thanks", ["Channel Name", "thanks"])

      @slack_channel_list_item.expect(:[], time, [:created])
      @existing_record.expect(:[]=, "07/04/2017", ["Creation Date", time.strftime("%m/%d/%Y")])

      @slack_channel_list_item.expect(:[], 2020, [:num_members])
      @existing_record.expect(:[]=, 2020, ["Membership", 2020])

      @slack_channel_list_item.expect(:[], @purpose = MiniTest::Mock.new, [:purpose])
      @purpose.expect(:[], purpose, [:value])
      @existing_record.expect(:[]=, purpose, ["Channel Purpose", purpose])

      @channel.expect(:latest, @latest = MiniTest::Mock.new)
      @latest.expect(:ts, nil)

      @slack_channel_list_item.expect(:[], true, [:is_archived])
      @existing_record.expect(:[]=, "Archived", ["Status", "Archived"])

      @channel.expect(:last_read, time.to_i)
      @existing_record.expect(:[]=, "", ["Last Activity", time.strftime("%m/%d/%Y")])

      @channel.expect(:topic, @topic = MiniTest::Mock.new)
      @topic.expect(:value, "Something topical")
      @existing_record.expect(:[]=, "", ["Channel Topic", "Something topical"])

      @existing_record.expect(:save, true)

      result = @subject.new(@params).call
      result.successful?.must_equal true
      result.must_be_kind_of PayDirt::Result
    end
  end

  describe "when creating" do
    it "executes successfully when creating" do
      time = Time.now
      @slack_channel_list_item.expect(:[], "123456789", [:id])
      @slack_channel_list_item.expect(:[], "thanks", [:name])
      @slack_channel_list_item.expect(:[], time, [:created])
      @slack_channel_list_item.expect(:[], 2020, [:num_members])
      @slack_channel_list_item.expect(:[], false, [:is_archived])
      @slack_channel_list_item.expect(:[], { value: "To rage against the dying of the light" }, [:purpose])

      @params[:table].expect(:all, [], [{filter: '{Channel Name} = "thanks"'}])
      @params[:slack_client].expect(:channels_info, @channel_info = MiniTest::Mock.new, [{channel: "123456789"}])
      @channel_info.expect(:channel, @channel = MiniTest::Mock.new)
      @channel.expect(:latest, @latest = MiniTest::Mock.new)
      @latest.expect(:ts, nil)
      @channel.expect(:last_read, time.to_i)
      @channel.expect(:topic, @topic = MiniTest::Mock.new)
      @topic.expect(:value, "Something topical")

      @params[:table].expect(:new, @new_record = MiniTest::Mock.new, [{
        "Channel Name"    => "thanks",
        "Creation Date"   => time.strftime("%m/%d/%Y"),
        "Membership"      => 2020,
        "Status"          => "Active",
        "Channel Purpose" => "To rage against the dying of the light",
        "Last Activity"   => time.strftime("%m/%d/%Y"),
        "Channel Topic"   => "Something topical",
      }])
      @new_record.expect(:create, true)

      result = @subject.new(@params).call
      result.successful?.must_equal true
      result.must_be_kind_of PayDirt::Result
    end
  end

  describe "when freaking out" do
    it "executes successfully when freaking out" do
      @params[:table].expect(:all, [0, 1], [{filter: '{Channel Name} = "thanks"'}])

      result = @subject.new(@params).call
      result.successful?.must_equal true
      result.must_be_kind_of PayDirt::Result
    end
  end
end
