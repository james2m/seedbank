Seedbank
========

Seedbank allows you to structure your Rails seed data instead of having it all dumped into one large file. I find my seed data tended to fall into two categories. 1. Stuff that the entire application requires. 2. Stuff to populate my development and staging environments.

Seedbank assumes common seed data is under db/seeds and any directories under db/seeds/ are specific to an environment, so db/seeds/development is contains all your development only seed data.

The reason behind Seedbank is laziness. When I checkout or re-visit a project I don't want to mess around getting my environment setup I just want the code and a database loaded with data in a known state. Since the Rails core team were good enough to give us rake db:setup it would be rude not to use it.

    rake db:setup  # Create the database, load the schema, and initialize with the seed data (use db:reset to also drop the db first)

To achieve this slothful aim Seedbank renames the original db:seed rake task to db:seed:original, makes it a dependency for all the Seedbank seeds and adds a new db:seed task that loads all the common seeds in db/seeds plus all the seeds for the current Rails environment.

Example
=======

Seedbank seeds follow this structure;

    db/seeds/
      bar.seeds.rb
      develpment/
        users.seeds.rb
      foo.seeds.rb

This would generate the following Rake tasks

    rake db:seed                    # Load the seed data from db/seeds.rb, db/seeds/*.seeds.rb and db/seeds/ENVIRONMENT/*.seeds.rb. ENVIRONMENT is the current environment in Rails.env.
    rake db:seed:bar                # Load the seed data from db/seeds/bar.seeds.rb
    rake db:seed:common             # Load the seed data from db/seeds.rb and db/seeds/*.seeds.rb.
    rake db:seed:development        # Load the seed data from db/seeds.rb, db/seeds/*.seeds.rb and db/seeds/development/*.seeds.rb.
    rake db:seed:development:users  # Load the seed data from db/seeds/development/users.seeds.rb
    rake db:seed:foo                # Load the seed data from db/seeds/foo.seeds.rb
    rake db:seed:original           # Load the seed data from db/seeds.rb

Therefor assuming RAILS_ENV is not set or is 'development'

    $ rake db:seed

would load the seeds in db/seeds.rb, db/seeds/bar.seeds.rb, db/seeds/foo.seeds/rb and db/seeds/development/users.seeds.rb. Whereas

    $ RAILS_ENV=production db:seed

would load the seeds in db/seeds.rb, db/seeds/bar.seeds.rb and db/seeds/foo.seeds/rb

Installation
============

### Rails 3.x

Add the seedbank gem to your Gemfile.  In Gemfile:

```ruby
gem "seedbank"
```

That's it!

### Rails 2.x

Add to your config/environment.rb

```ruby
config.gem 'seedbank'
```

Install the gem;

    $ rake gems:install

Then in the bottom of your application's Rakefile:

```ruby
require 'seedbank'
Seedbank.load_tasks if defined?(Seedbank)
```

If you vendor the gem you'll need to change the require to the specific path.

Contributors
============
```shell
git log | grep Author | sort | uniq
```

* James McCarthy
* Andy Triggs
* Philip Arndt

Note on Patches/Pull Request
============================

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it (when I have some). This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but
  bump version in a commit by itself I can ignore it when I pull)
* Send me a pull request.  Bonus points for topic branches.

Copyright
=========
Copyright (c) 2011 James McCarthy, released under the MIT license
