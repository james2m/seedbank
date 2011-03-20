Seedbank
========

Seedbank allows you to structure your Rails seed data instead of having it all dumped into one large file. 

Seedbank renames the original db:seed rake task to db:seed:original and makes it a dependency for all the other seeds. A new db:seed task is created that is dependent on db:seed:original, all the seeds in db/seeds plus all the seeds in the current Rails environment.
  
Example
=======

Your Seedbank seeds follow this structure;

    db/seeds/
      bar.seeds.rb
      develpment/
        users.seeds.rb
      foo.seeds.rb
  
This would generate the following Rake tasks

    rake db:seed                    # Loads the original seeds in db/seeds.rb followed by db/seeds/*.seeds.rb then db/seeds/environment/*.seeds.rb
    rake db:seed:bar                # Loads seeds from bar.seeds.rb
    rake db:seed:development        # Load just the seeds for the development environment
    rake db:seed:development:users  # Loads seeds from development/users.seeds.rb
    rake db:seed:foo                # Loads seeds from foo.seeds.rb
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

    gem "seedbank"

That's it!

### Rails 2.x

Add the seedbank gem to your app. In config/environment.rb:

    config.gem 'seedbamk'

Then in the bottom of your applications Rakefile:

    Seedbank.load_tasks

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
