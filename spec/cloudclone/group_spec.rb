describe Cloudclone::Group do

  let(:group_name) { "group-name" }
  let(:heroku) { mock(Heroku::Client).as_null_object }
  subject { Cloudclone::Group.new("group-name", heroku) }

  describe "#new" do
    it "should receive group name and Heroku object" do
      Cloudclone::Group.new(group_name, instance_of(Heroku::Client)).should_not be_nil
    end
  end

  describe "#name" do
    it "should return group name" do
      subject.name.should == group_name
    end
  end

  describe "#destroy" do
    it "should call Heroku to destroy every apps in group" do
      email = "any@em.ail"
      apps = [["cc-#{group_name}-1", email], ["cc-#{group_name}-2", email],
        ["otherapp"], email]
      heroku.should_receive(:list).and_return(apps)
      heroku.should_receive(:destroy).with(apps[0][0])
      heroku.should_receive(:destroy).with(apps[1][0])
      subject.destroy
    end
  end

end
