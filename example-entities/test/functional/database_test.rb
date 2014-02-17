# Encoding: utf-8

require_relative '../test_helper'

# Mock namespace
module Something
end

describe 'Database setup and connection providers are working' do
  let (:config_path) { File.join(File.dirname(__FILE__), '../../config') }
  let (:config_file) { 'database.yml' }

  before do
    Configuration.base_path = 'config'
  end

  it 'database is configured' do
    db_config = Database.database_config
    refute_empty db_config
    assert_equal db_config[:test][:driver], 'PostgreSQL'
  end

  it 'generates a DSN that will work with Sequel' do
    dsn = Database.sequel_dsn

    assert dsn.start_with? 'postgres://'

    db = Database.db_connect
    assert db.test_connection, 'Database failed to connect on Sequel'
    Database.disconnect(db)
    db.pool.size.must_equal 0
  end

  it 'can setup a configured database connection and connect ' do
    was_here = false
    db = Database.db_setup(single_threaded: true) do |conn|
      conn.must_be_kind_of Sequel::Database
      was_here = true
    end

    was_here.must_equal true
    db.must_be_kind_of Sequel::Database

    Database.disconnect(db)
    db.pool.size.must_equal 0
  end
end
