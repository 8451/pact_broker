# Pact Broker

The Pact Broker provides a repository for pacts created using the pact gem. It solves the problem of how to share pacts between consumer and provider projects.

The Pact Broker:

* Enables pacts to be shared between consumer and provider projects.
* Enables a provider to be verified as being backwards compatible with the production version of a consumer pact by supporting tagging of pacts.
* Provides webhooks to trigger a provider build when a consumer publishes a change to a pact.
* Displays dynamically generated network diagrams.

See the [Pact Broker Client](https://github.com/bethesque/pact_broker-client) for documentation on how to publish a pact to the Pact Broker, and configure the URLs in the provider project.

## Documentation

See the [wiki](https://github.com/bethesque/pact_broker/wiki) for documentation.

## Usage

* Create a database using a product that is supported by the Sequel gem (listed on this page http://sequel.jeremyevans.net/rdoc/files/README_rdoc.html). At time of writing, Sequel has adapters for:  ADO, Amalgalite, CUBRID, DataObjects, DB2, DBI, Firebird, IBM_DB, Informix, JDBC, MySQL, Mysql2, ODBC, OpenBase, Oracle, PostgreSQL, SQLAnywhere, SQLite3, Swift, and TinyTDS
* Install ruby 1.9.3 or later
* Copy the [example](/example) directory to your workstation.
* Modify the config.ru and Gemfile as desired (eg. choose database driver gem, set your database credentials)
* Run `bundle`
* Run `bundle exec rackup`
* Open [http://localhost:9292](http://localhost:9292) and you should see the HAL browser.

For production usage, use a web application server like [Phusion Passenger](https://www.phusionpassenger.com) to serve the Pact Broker application.
