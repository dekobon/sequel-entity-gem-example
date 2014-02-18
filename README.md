Cross Module Sequel Model Example
==================================

Summary
--------

This project contains two gems: ```example-entities``` and ```application```.

```example-entities``` contains:
 * An example of a Sequel database handle configuration pattern.
 * Sequel Active Record models that can be extended in other projects.

```application``` contains:
 * An example for extending the imported Sequel models with functionality
   local to the importing gem.
 * An example of using the database setup utility functions.

Database
---------

Due to time constraints, I was only able to make the example work with
PostgreSQL. It should be trivial to use the pattern to implement other
databases.

Running the Examples
---------------------

 1. Setup a PostgreSQL database (or borrow one from Heroku) and make sure
    that your credentials are set in both projects' config/database.yml
 2. Do a bundle install in both the example-entities and application
    directories.
 3. For the entities example, enter the example-entities directory and do
    ```rake db:migrate test```. If you have create/drop access to the database
    then db:reset should work as well.
 4. For the application example, enter the application directory and
    do ```rake test```. You will see a single test succeed.
