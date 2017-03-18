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

  describe "as an instance" do
    it "executes successfully" do
      result = @subject.new(@params).call
      result.successful?.must_equal true
      result.must_be_kind_of PayDirt::Result
    end
  end
end
