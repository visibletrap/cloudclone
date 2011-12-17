require 'cloudclone/client'

describe Cloudclone::Client do

  subject { Cloudclone::Client.new('username', 'password') }

  describe "#create" do
    it "should create Heroku apps" do
      (1..10).each do |n|
        Heroku::Client.any_instance.should_receive(:create).
          with("cc-prefix-#{n}")
      end
      subject.create('prefix', 10)
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

  describe "#groups" do
    it "should use result from list to return as group objects" do
      names = ["groupa", "groupb"]
      subject.should_receive(:list).and_return(names)
      groups = subject.groups
      groups.count.should == names.count
      names.should include(groups[0].name)
      names.should include(groups[1].name)
    end
  end

  describe "#destroy" do
    it "should call Group to destroy" do
      group = mock(Cloudclone::Group)
      group.stub(:name).and_return("group_name")
      subject.stub(:groups).and_return([group])
      group.should_receive(:destroy)

      subject.destroy("group_name")
    end
  end

end
