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
    it "should deploy cloudclone-server to app instances" do
      require 'rest_client'
      RestClient.get("http://#{app_names[0]}.heroku.com").should =~ /Cloudclone installed/
      RestClient.get("http://#{app_names[1]}.heroku.com").should =~ /Cloudclone installed/
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

  describe "#list" do
    let(:group_name) { ["list-group-name-1", "list-group-name-2"] }
    it "should return group names" do
      subject.create(group_name[0], 1)
      subject.create(group_name[1], 1)

      subject.list.should == group_name
    end
    after do
      group_name.each{ |n| heroku.destroy("cc-#{n}-1") }
    end
  end

  describe "#group" do
    before(:all) do
      subject.create("valid-group-name", 1)
    end
    context "valid group name" do
      it { subject.group("valid-group-name").should be_kind_of(Cloudclone::Group) }
    end
    context "invalid group name" do
      it { subject.group("invali-group-name").should be_nil }
    end
    after(:all) do
      heroku.destroy("cc-valid-group-name-1");
    end
  end

  describe "#groups" do
    let(:group_name) { ["groups-group-name-1", "groups-group-name-2"] }
    it "should return group objects" do
      subject.create(group_name[0], 1)
      subject.create(group_name[1], 1)

      app_groups = subject.groups
      app_groups[0].should be_kind_of(Cloudclone::Group)
      app_groups[0].name.should == group_name[0]
      app_groups[1].should be_kind_of(Cloudclone::Group)
      app_groups[1].name.should == group_name[1]
    end
    after do
      group_name.each{ |n| heroku.destroy("cc-#{n}-1") }
    end
  end

end
