# api

This API is designed for managing dance events, specifically for tango groups.

## Requirements

- [PostgreSQL](https://www.postgresql.org)
  - For Mac users, I'd recommend the wonderful [Postgres.app](http://postgresapp.com/)
  - For Windows users, take a look at the [downloads page](https://www.postgresql.org/download/windows/) (sorry, I'm not too well versed in this)

## Getting Started

:gem: Ensure you have a modern version of ruby installed on your system. [ruby-lang.org](https://www.ruby-lang.org/en/) has good documentation on how to do this.

:package: Install dependencies by running `bundle` inside the folder of the project.

:book: Setup the database by running `bin/rails db:create`, and `bin/rails db:migrate`

:dancer: Start up the application by running `bin/rails s`

## Where is this hosted?

This is currently hosted on Heroku, but may be put onto AWS for reliability and scaling across regions.
