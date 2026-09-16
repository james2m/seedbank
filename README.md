<!-- README.md -->
Seedbank
========

Works fine with Rails 8!

Seedbank allows you to structure your apps seed data instead of having it all dumped into one large file. I find my seed data tended to fall into two categories:

1. Stuff that the entire application requires.
2. Stuff to populate my development and staging environments.

Seedbank assumes that your common seed data is kept under db/seeds and any directories under `db/seeds/` are specific to an environment, so `db/seeds/development` contains all your **development-only** seed data.

The reason behind Seedbank is laziness. When I checkout or re-visit a project I don't want to mess around getting my environment setup I just want the code and a database loaded with data in a known state. Since the Rails core team were good enough to give us `bin/rails db:setup` it would be rude not to use it.

    bin/rails db:setup  # Create the database, load the schema, and initialize with the seed data (use db:reset to also drop the db first)

To achieve this slothful aim, Seedbank renames the original db:seed rake task to db:seed:original, makes it a dependency for all the Seedbank seeds and adds a new db:seed task that loads all the common seeds in db/seeds plus all the seeds for the current Rails environment.

Although originally built for Rails, Seedbank can work stand alone thanks to Aleksey Ivanov.

[![CI](https://github.com/scarver2/seedbank/actions/workflows/ci.yml/badge.svg)](https://github.com/scarver2/seedbank/actions/workflows/ci.yml)

Example
=======

Seedbank seeds follow this structure:

    db/seeds/
      bar.seeds.rb
      development/
        users.seeds.rb
      foo.seeds.rb

This would generate the following Rake tasks

    bin/rails db:seed                    # Load db/seeds.rb, common seeds, and seeds for Rails.env.
    bin/rails db:seed:bar                # Load db/seeds/bar.seeds.rb.
    bin/rails db:seed:common             # Load db/seeds.rb and db/seeds/*.seeds.rb.
    bin/rails db:seed:development        # Load common and development seed data.
    bin/rails db:seed:development:users  # Load db/seeds/development/users.seeds.rb.
    bin/rails db:seed:original           # Load db/seeds.rb.

Therefore, assuming `RAILS_ENV` is not set or it is "development":

    $ bin/rails db:seed

will load the seeds in `db/seeds.rb`, `db/seeds/bar.seeds.rb`, `db/seeds/foo.seeds.rb` and `db/seeds/development/users.seeds.rb`. Whereas, setting the `RAILS_ENV` variable, like so:

    $ RAILS_ENV=production bin/rails db:seed

will load the seeds in `db/seeds.rb`, `db/seeds/bar.seeds.rb` and `db/seeds/foo.seeds.rb`.

Installation
============

Seedbank supports maintained Ruby releases: Ruby 3.3, 3.4, and 4.0. Ruby 3.2
and older are no longer supported as of the next Seedbank release.

Seedbank supports Rails 8.0 and 8.1. Rails 7.2 and older are no longer
supported as of the next Seedbank release.

Add Seedbank to your Rails application's Gemfile:

```ruby
gem "seedbank"
```

That's it!

Then run `bundle install`. Seedbank's Railtie loads its tasks automatically.

### Non-Rails apps

Seedbank can also load its Rake tasks without Rails. Add this to your Rakefile:

```ruby
require 'seedbank'
Seedbank.load_tasks if defined?(Seedbank)
```

Run tasks with `bundle exec rake db:seed`. The generated Rake task names and
dependency behavior are the same as in Rails.

Usage
=====

Seeds files are just plain old Ruby executed in your application environment so anything you could type into the console will work in your seeds. Seeds files have to be named with the '.seeds.rb' extension.

db/seeds/companies.seeds.rb
```ruby
Company.find_or_create_by!(name: 'Hatch', url: 'https://thisishatch.co.uk')
```

The seed files under db/seeds are run first in alphanumeric order followed by the ones in the db/seeds/RAILS_ENV. You can add dependencies to your seed files
to enforce the run order. for example;

db/seeds/users.seeds.rb
```ruby
after :companies do
  company = Company.find_by!(name: 'Hatch')
  company.users.create!(first_name: 'James', last_name: 'McCarthy')
end
```

db/seeds/projects.seeds.rb
```ruby
after :companies do
  company = Company.find_by!(name: 'Hatch')
  company.projects.create!(title: 'Seedbank')
end
```

db/seeds/tasks.seeds.rb
```ruby
after :projects, :users do
  project = Project.find_by!(name: 'Seedbank')
  user = User.find_by!(first_name: 'James', last_name: 'McCarthy')
  project.tasks.create!(owner: user, title: 'Document seed dependencies in the README.md')
end
```

If the dependencies are in one of the environment folders, you need to namespace the parent task:

db/seeds/development/users.seeds.rb
```ruby
after "development:companies" do
  company = Company.find_by!(name: 'Hatch')
  company.users.create!(first_name: 'James', last_name: 'McCarthy')
end
```

*Note* - If you experience any errors like `Don't know how to build task 'db:seed:users'`. Ensure you are specifying `after 'development:companies'` like the above example. This is the usual culprit (YMMV).

### Defining and using methods

As seed files are evaluated within a single runner in dependency order, any methods defined earlier in the run will be available across dependent tasks. I
recommend keeping method definitions in the seed file that uses them. Alternatively if you have many common methods, put them into a module and extend the
runner with the module.

db/seeds/support.rb
```ruby
module Support
  def notify(filename)
    puts "Seeding: #{filename}"
  end
end
```

db/seeds/common.seeds.rb
```ruby
require_relative 'support'
extend Support

notify(__FILE__)
```

To keep this dry you could make the seeds dependent on a support seed that extends the runner.

db/seeds/users.seeds.rb
```ruby
after :common do
  notify(__FILE__)
end
```

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
* Aleksey Ivanov

Contributing
============

1. Fork the project and create a focused topic branch.
2. Install dependencies with Bundler.
3. Add behavior-focused tests for the change.
4. Run the supported dependency sets:

```shell
BUNDLE_GEMFILE=gemfiles/rails_8_0.gemfile bundle exec rake test
BUNDLE_GEMFILE=gemfiles/rails_8_1.gemfile bundle exec rake test
```

5. Open a pull request describing the change and test evidence. Please keep
   version bumps in a separate commit when a release requires one.

Copyright
=========
Copyright (c) 2011-2017 James McCarthy, released under the MIT license
