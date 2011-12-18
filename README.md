Cloudclone
==========

Library for manage multiple Heroku apps to do parallel HTTP request to certain web servers.

This gem enable you to easily utilize free Heroku apps to build your own web load testing servers.

Current key features
--------------------

* Create Heroku instances which will be deployed with [cloudclone-server](https://github.com/visibletrap/cloudclone-server).
* Make HTTP request to any HTTP web server via those Heroku instances.

##Installation

    gem install cloudclone

##Examples

    require 'cloudclone'
    cloudclone = Cloudclone::Client.new("heroku_username", "heroku_password")
    cloud_group = cloudclone.create("group_name", 3)
    cloud_group.request("http://www.google.com")

##Requirement

* [git](http://git-scm.com/)
* [Heroku](http://www.heroku.com) account with ssh key access installed.

##Short Documentation

    # Create Cloundclone client instance
    cloudclone = Cloudclone::Client.new(heroku_username, heroku_password)

    # Create and deploy cloudclone-server to multiple Heroku apps
    cloud_group = cloudclone.create(group_name, no_of_apps)

    # Make multiple request to web server
    cloud_group.request(url)

    # Remove multiple Heroku apps
    cloudclone.destroy(group_name)
    cloud_group.destroy

    # Array of all Cloudclone group names
    group_names = cloudclone.list

    # Retrieve Cloudclone group object from group name
    cloud_group = cloudclone.group(group_name)

    # Array of all Cloudclone group objects
    cloud_groups = cloudclone.groups

