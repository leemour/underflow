Overview
====================
__Underflow__ is a Questions and Answers platform, built with Ruby on Rails.

Technically, it's a [stackoverflow](http://stackoverflow.com) clone.

Features
--------
- Tags
- Comments
- Views
- Votes
- User profiles
- Wisywig editor
- Notifications
- Badges

### Dependencies:

- Ruby 2.3.6
- Rails 4.2
- PostgreSQL
- Unicorn
- Faye (based on Node.JS) for pub/sub
- Thin (for Faye)
- RSpec
- Capistrano
- Redis
- Sphinx search
- MySQL (for Sphinx Search)
- SASS

## Installation
Steps:

    $ bundle

Create user `underflow` in PostgreSQL with DB `underflow`:

    $ sudo su postgres
    $ createuser -S -d -R -e -l -P underflow

File `db/database.yml` uses credentials from `secrets.yml`. it __is__ supposed to be in repository and it should be __unchanged__. Edit `secrets.yml` to set your credentials. Keep all secrets inside `secrets.yml` as it's added to `.gitignore`.

Create DB, run migrations and seed (if any seeds) for test & development:

    $ rails db:setup
    $ RAILS_ENV=test rails db:setup

If migrations fail because of `hstore`:

    $ sudo apt-get install postgresql-contrib
    $ sudo su postgres
    $ psql -d underflow_dev
    # inside psql
    $ CREATE EXTENSION hstore;
    $ \c underflow_test
    $ CREATE EXTENSION hstore;

OR
    $ sudo su postgres -c "psql underflow_dev -c 'CREATE EXTENSION hstore;'"

## Usage
Server:

    $ spring rails server

PrivatePub:

    $ rackup private_pub.ru -s thin -E production


### I18n

Fully internationalized with Russian and English languages available.

### License

MIT license: See license doc
