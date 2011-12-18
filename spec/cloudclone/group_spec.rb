describe Cloudclone::Group do

  let(:group_name) { "group-name" }
  let(:heroku) { mock(Heroku::Client).as_null_object }
  subject { Cloudclone::Group.new(group_name, heroku) }

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
        ["otherapp", email], ["cc-othergroup-1", email]]
      heroku.should_receive(:list).and_return(apps)
      heroku.should_receive(:destroy).with(apps[0][0])
      heroku.should_receive(:destroy).with(apps[1][0])
      heroku.should_not_receive(:destroy).with(apps[2][0])
      heroku.should_not_receive(:destroy).with(apps[3][0])
      subject.destroy
    end
  end

  describe "#request" do
    it "should request with provide link as url paramter to servers" do
      app_names = (1..20).map{ |i| "cc-#{group_name}-#{i}" }
      subject.stub(:all_app_names).and_return(app_names)
      app_names.each do |n|
        RestClient.should_receive(:get).with("http://#{n}.heroku.com/?url=http://www.google.com")
      end
      subject.request("http://www.google.com")
    end
  end

end
