require 'test_helper'

describe Prog::Channels::Syncopator do
  before do
    @subject = Prog::Channels::Syncopator
    @params = {
      table:        MiniTest::Mock.new,
      slack_client: MiniTest::Mock.new,
    }

    # Airtable expectations
    @params[:table].expect(:kind_of?,     true, [Airrecord::Table])

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
      @airtable_match.expect(:id, "rec123")
      @params[:table].expect(:find, @existing_record = MiniTest::Mock.new, ["rec123"])

      time = Time.now
      @slack_channel_list_item.expect(:[], "thanks", [:name])
      @slack_channel_list_item.expect(:[], time, [:created])
      @slack_channel_list_item.expect(:[], 2020, [:num_members])
      @slack_channel_list_item.expect(:[], true, [:is_archived])

      @existing_record.expect(:[]=, "thanks", ["ZChannel Name", "thanks"])
      @existing_record.expect(:[]=, "thanks", ["ZCreation Date", time.strftime("%Y-%m-%d")])
      @existing_record.expect(:[]=, "thanks", ["ZMembership Range", 2020])
      @existing_record.expect(:[]=, "thanks", ["ZStatus", "Archived"])

      result = @subject.new(@params).call
      result.successful?.must_equal true
      result.must_be_kind_of PayDirt::Result
    end
  end

  describe "when creating" do
    it "executes successfully when creating" do
      time = Time.now
      @slack_channel_list_item.expect(:[], "thanks", [:name])
      @slack_channel_list_item.expect(:[], time, [:created])
      @slack_channel_list_item.expect(:[], 2020, [:num_members])

      @params[:table].expect(:all, [], [{filter: '{Channel Name} = "thanks"'}])
      @params[:table].expect(:new, @new_record = MiniTest::Mock.new, [{
        "ZChannel Name"     => "thanks",
        "ZCreation Date"    => time.strftime("%Y-%m-%d"),
        "ZMembership Range" => 2020,
        "ZChannel Type"     => "New",
        "ZStatus"           => "Active",
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
