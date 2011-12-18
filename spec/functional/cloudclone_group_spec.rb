require 'spec_helper'
require 'cloudclone/client'
require 'cloudclone/group'

describe "Cloudclone" do

  let(:username) { ENV['HEROKU_USERNAME'] }
  let(:password) { ENV['HEROKU_PASSWORD'] }

  describe "#request" do
    it "should send request to provided url" do
      WebMock.allow_net_connect!
      subject = Cloudclone::Client.new(username, password).create("group-test", 2)
      subject.request("http://www.google.com")
      WebMock.should have_requested(:get, "cc-group-test-1.heroku.com/?url=http://www.google.com")
      WebMock.should have_requested(:get, "cc-group-test-2.heroku.com/?url=http://www.google.com")
    end
  end

  after(:all) do
    Heroku::Client.new(username, password).destroy("cc-group-test-1")
    Heroku::Client.new(username, password).destroy("cc-group-test-2")
  end

end
