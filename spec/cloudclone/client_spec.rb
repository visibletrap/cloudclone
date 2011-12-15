require 'spec_helper'
require 'cloudclone/client'

describe Cloudclone::Client do

  subject { Cloudclone::Client.new('username', 'password') }

  describe "#new" do
    it "receive username and password of Heroku account" do
      Cloudclone::Client.new('username', 'password').should_not be_nil
    end
  end

  describe "#create" do
    it "should create Heroku apps" do
      (1..10).each do |n|
        Heroku::Client.any_instance.should_receive(:create).
          with("cc-prefix-#{n}")
      end
      subject.create('prefix', 10)
    end
    it "should return created app names as an array" do
      (1..2).each do |n|
        name = "cc-prefix-#{n}"
        Heroku::Client.any_instance.stub(:create).with(name).
          and_return(name)
      end
      subject.create('prefix', 2).should == ['cc-prefix-1', 'cc-prefix-2']
    end
  end

  describe "#list" do
    it "should list all Cloudclone groups" do
      email = "not@interest.ing"
      heroku_response = [["otherapps", email], ["cc-groupa-1", email],
        ["cc-groupa-2", email], ["cc-groupb-1", email]]
      Heroku::Client.any_instance.should_receive(:list).
        and_return(heroku_response)
      subject.list.should == ['groupa', 'groupb']
    end
  end

end
