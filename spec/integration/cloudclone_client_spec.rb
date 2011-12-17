require 'cloudclone/client'
require 'cloudclone/group'

describe "Cloudclone" do

  let(:username) { ENV['HEROKU_USERNAME'] }
  let(:password) { ENV['HEROKU_PASSWORD'] }

  subject { Cloudclone::Client.new(username, password) }

  let(:heroku) { subject.heroku }

  describe "#new" do
    it "receive username and password of Heroku account" do
      Cloudclone::Client.new(username, password).should_not be_nil
    end
  end

  describe "#create" do
    let(:group_name) { "create-group-name" }
    let(:app_names) { (1..2).map{ |n| "cc-#{group_name}-#{n}"} }

    before(:all) do
      @output = subject.create(group_name, 2)
    end
    it "create certain amount of heroku apps which name contains group name" do
      heroku.list.map{ |e| e[0] }.should == app_names
    end
    it "should return Cloundclone::Group object" do
      @output.should be_kind_of(Cloudclone::Group)
    end
    after(:all) do
      app_names.each{ |a| heroku.destroy(a) }
    end
  end

  describe "#destroy" do
    it "receive an existing group name return true" do
      subject.create("destroy-group-name", 2)
      subject.destroy("destroy-group-name").should be_true
    end
  end

end
