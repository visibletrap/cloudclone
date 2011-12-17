require 'cloudclone'
require 'heroku'
require 'cloudclone/group'

class Cloudclone::Client

  attr_reader :heroku

  def initialize(username, password)
    @heroku = Heroku::Client.new(username, password)
  end

  def create(name_prefix, no_of_apps)
    (1..no_of_apps).each do |n|
      @heroku.create("cc-#{name_prefix}-#{n}")
    end
    Cloudclone::Group.new(name_prefix, @heroku)
  end

  def list
    @heroku.list.map { |e| e[0].match(/^cc-(.+)-1$/) }.compact.
      map { |e| e.captures }.flatten
  end

  def destroy(group_name)
    groups.select { |g| g.name == group_name }.each { |g| g.destroy }
  end

  def groups
    list.map { |name| Cloudclone::Group.new(name, @heroku) }
  end

end
