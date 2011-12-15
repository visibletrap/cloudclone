require 'cloudclone'
require 'heroku'

class Cloudclone::Client

  def initialize(username, password)
    @heroku = Heroku::Client.new(username, password)
  end

  def create(name_prefix, no_of_apps)
    (1..no_of_apps).inject([]) do |names, n|
      names << @heroku.create("cc-#{name_prefix}-#{n}")
    end
  end

  def list
    @heroku.list.map { |e| e[0].match(/^cc-(.+)-1$/) }.compact.
      map { |e| e.captures }.flatten
  end

end
