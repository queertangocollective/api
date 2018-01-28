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

This is hosted on AWS, using Elastic Beanstalk. AWS is a bit _involved_. For a quick rundown of what you need to know to administer this, see below.

## Deploying

:seedling: To deploy the api, you'll need to install the AWS elastic beanstalk command line tool.

On mac, this is fairly straightfoward with the command:

```bash
brew install awsebcli
```

Next thing is to get permission to deploy. Get in touch with one of the administrators and ask to get a user account on AWS. This will give you an access ID and a secret key which you'll use to login.

To start connecting to the app, run `eb init`. This will take you through a series of steps that will end up setting up your connection to the api. Once done, you should be able to deploy using `eb deploy`.