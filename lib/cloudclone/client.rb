require 'cloudclone'
require 'heroku'
require 'cloudclone/group'

class Cloudclone::Client

  attr_reader :heroku

  def initialize(username, password)
    @heroku = Heroku::Client.new(username, password)
  end

  def create(group_name, no_of_apps)
    begin
      clone_server
      Dir.chdir('cloudclone-server')
      (1..no_of_apps).each do |n|
        app_name = "cc-#{group_name}-#{n}"
        @heroku.create(app_name)
        add_remote(app_name)
        push(app_name)
      end
    ensure
      Dir.chdir('..')
      FileUtils.rm_rf('../cloudclone/cloudclone-server')
    end
    Cloudclone::Group.new(group_name, @heroku)
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

  private
  def clone_server
    `git clone git://github.com/visibletrap/cloudclone-server.git`
  end

  def add_remote(app_name)
    `git remote add #{app_name} git@heroku.com:#{app_name}.git`
  end

  def push(app_name)
    `heroku accounts:set #{ENV['HEROKU_ACCOUNT']}` if ENV['HEROKU_ACCOUNT']
    `git push #{app_name} master`
  end

end
