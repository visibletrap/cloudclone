describe Cloudclone::Group do

  describe "#new" do
    it "should receive group name" do
      Cloudclone::Group.new("group_name").should_not be_nil
    end
  end

end
