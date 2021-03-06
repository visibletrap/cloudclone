require 'cloudclone'

class Cloudclone::Group

  def initialize(group_name, heroku)
    @group_name = group_name
    @heroku = heroku
  end

  def name
    @group_name
  end

  def destroy
    app_names.each{ |n| @heroku.destroy(n) }
  end

  def request(url)
    app_names.each { |n| RestClient::get("http://#{n}.heroku.com/?url=#{url}") }
  end

  private
  def app_names
    all_app_names.select{ |n| n =~ /^cc-#{@group_name}-\d+$/ }
  end

  def all_app_names
    @heroku.list.map{ |e| e[0] }
  end

end
