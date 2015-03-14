Seedbank
========

Seedbank allows you to structure your Rails seed data instead of having it all dumped into one large file. I find my seed data tended to fall into two categories:

1. Stuff that the entire application requires. 
2. Stuff to populate my development and staging environments.

Seedbank assumes that your common seed data is kept under db/seeds and any directories under `db/seeds/` are specific to an environment, so `db/seeds/development` contains all your **development-only** seed data.

The reason behind Seedbank is laziness. When I checkout or re-visit a project I don't want to mess around getting my environment setup I just want the code and a database loaded with data in a known state. Since the Rails core team were good enough to give us rake db:setup it would be rude not to use it.

    rake db:setup  # Create the database, load the schema, and initialize with the seed data (use db:reset to also drop the db first)

To achieve this slothful aim, Seedbank renames the original db:seed rake task to db:seed:original, makes it a dependency for all the Seedbank seeds and adds a new db:seed task that loads all the common seeds in db/seeds plus all the seeds for the current Rails environment.

Example
=======

Seedbank seeds follow this structure;

    db/seeds/
      bar.seeds.rb
      development/
        users.seeds.rb
      foo.seeds.rb

This would generate the following Rake tasks

    rake db:seed                    # Load the seed data from db/seeds.rb, db/seeds/*.seeds.rb and db/seeds/ENVIRONMENT/*.seeds.rb. ENVIRONMENT is the current environment in Rails.env.
    rake db:seed:bar                # Load the seed data from db/seeds/bar.seeds.rb
    rake db:seed:common             # Load the seed data from db/seeds.rb and db/seeds/*.seeds.rb.
    rake db:seed:development        # Load the seed data from db/seeds.rb, db/seeds/*.seeds.rb and db/seeds/development/*.seeds.rb.
    rake db:seed:development:users  # Load the seed data from db/seeds/development/users.seeds.rb
    rake db:seed:original           # Load the seed data from db/seeds.rb

Therefore, assuming `RAILS_ENV` is not set or it is "development":

    $ rake db:seed

will load the seeds in `db/seeds.rb`, `db/seeds/bar.seeds.rb`, `db/seeds/foo.seeds.rb` and `db/seeds/development/users.seeds.rb`. Whereas, setting the `RAILS_ENV` variable, like so:

    $ RAILS_ENV=production db:seed

will load the seeds in `db/seeds.rb`, `db/seeds/bar.seeds.rb` and `db/seeds/foo.seeds.rb`.

Installation
============

### Rails 3.x and 4.x

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

Install the gem:

    $ rake gems:install
    
Or, if you're using Bundler:

    $ bundle install

Then in the bottom of your application's Rakefile:

```ruby
require 'seedbank'
Seedbank.load_tasks if defined?(Seedbank)
```

If you vendor the gem you'll need to change the require to the specific path.

Usage
=====

Seeds files are just plain old Ruby executed in your rails application environment so anything you could type into the rails console will work in your seeds. Seeds files have to be named with the '.seeds.rb' extension.

db/seeds/companies.seeds.rb
```ruby
Company.find_or_create_by_name('Hatch', :url => 'http://thisishatch.co.uk' )
```

The seed files under db/seeds are run first in alphanumeric order followed by the ones in the db/seeds/RAILS_ENV. You can add dependencies to your seed files
to enforce the run order. for example;

db/seeds/users.seeds.rb
```ruby
after :companies do
  company = Company.find_by_name('Hatch')
  company.users.create(:first_name => 'James', :last_name => 'McCarthy')
end
```

db/seeds/projects.seeds.rb
```ruby
after :companies do
  company = Company.find_by_name('Hatch')
  company.projects.create(:title => 'Seedbank')
end
```

db/seeds/tasks.seeds.rb
```ruby
after :projects, :users do
  project = Project.find_by_name('Seedbank')
  user = User.find_by_first_name_and_last_name('James', 'McCarthy')
  project.tasks.create(:owner => user, :title => 'Document seed dependencies in the README.md')
end
```

If the dependencies are in one of the environment folders, you need to namespace the parent task:

db/seeds/development/users.seeds.rb
```ruby
after "development:companies" do
  company = Company.find_by_name('Hatch')
  company.users.create(:first_name => 'James', :last_name => 'McCarthy')
end
```

### Defining and using methods

As seed files are evaluated within blocks, methods need to be defined and used as per below:

```ruby
class << self
  def create_user name
    user = User.where(name: name).first_or_create
    # ...
  end
end

['Greg', 'Daniel'].each do |name|
  create_user name
end
```

*Note* - If you experience any errors like `Don't know how to build task 'db:seed:users'`. Ensure your specifying `after 'development:companies'` like the above example. This is the usual culprit (YMMV).

Contributors
============
```shell
git log | grep Author | sort | uniq
```

* Ahmad Sherif
* Andy Triggs
* Corey Purcell
* James McCarthy
* Joost Baaij
* Justin Smestad
* Peter Suschlik
* Philip Arndt
* Tim Galeckas
* lulalala
* pivotal-cloudplanner
* vkill


Note on Patches/Pull Request
============================

* Fork the project.
* Make your feature addition or bug fix.
* Add tests for it. This is important so I don't break it in a future version unintentionally.
* Commit, do not mess with rakefile, version, or history. (if you want to have your own version, that is fine but
  bump version in a commit by itself I can ignore it when I pull)
* Send me a pull request.  Bonus points for topic branches.

Copyright
=========
Copyright (c) 2011-2015 James McCarthy, released under the MIT license
