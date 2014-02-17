# Encoding: utf-8

##
# Generic Database module representing a set of database configuration
# and setup functionality used with Sequel.
module Database
  class << self
    def initialize
      @db_config = nil
    end

    ##
    # Load database credentials from the database.yml configuration ala Rails
    # We load it once into memory here. You will need to restart the app to
    # load any changes.
    def database_config
      unless defined?(@db_config) && @db_config
        @db_config = Configuration.load_yaml_config(
            Configuration.base_path, 'database.yml')
      end

      @db_config
    end

    ##
    # Create a Sequel style DSN for use with connecting to the environment's
    # specified database.
    # @return [String] DSN formatted for use with Sequel
    def sequel_dsn
      config = Database.database_config[environment]
      driver = config[:driver].downcase
      # Deal with string conversion for postgres. Every other db access tech
      # for Ruby uses postgresql, but for some reason sequel uses the
      # abbreviated form.
      vendor = driver == 'postgresql' ? 'postgres' : driver

      "#{vendor}://#{config[:username]}:#{config[:password]}" +
          "@#{config[:host]}:#{config[:port]}/#{config[:database]}"
    end

    ##
    # Opens a connection to the database.
    # @return [Sequel::Database] database handle
    def db_connect
      dsn = sequel_dsn

      is_postgres = dsn.start_with?('postgres') ||
                    dsn.start_with?('jdbc:postgres')

      is_jruby = RUBY_PLATFORM =~ /java/

      if is_postgres
        Sequel.extension :pg_array_ops
        Sequel::Database.extension :pg_array
        Sequel::Database.extension :pg_hstore
        Sequel::Database.extension :pg_json
        Sequel::Database.extension :pg_inet

        unless is_jruby
          Sequel::Database.extension :pg_streaming
        end
      end

      Sequel.connect(dsn).tap do |db|
        setup_citext_type(db) if is_postgres
      end
    end

    ##
    # Opens a connection to the database and sets up extensions and all of the
    # prepare statements that will live for the life of the connection.
    # @return [Sequel::Database] database handle
    def db_setup(options = {}, &block)
      # noinspection RubySimplifyBooleanInspection
      Sequel.single_threaded = (options.andand[:single_threaded] == true)

      db_connect.tap do |db|
        if options[:use_models]
          Sequel::Model.db = db

          if options[:use_prepares]
            Sequel::Model.plugin :prepared_statements
            Sequel::Model.plugin :prepared_statements_associations
          end

          require_relative '../models.rb'
        end

        if db.respond_to?(:stream_all_queries) && options[:stream_all_queries]
          db.stream_all_queries = options[:stream_all_queries]
        end

        block.call(db) if block_given?
      end
    end

    ##
    # Sets up a support for the citext PostgreSQL datatype.
    # @param db [Sequel::Database] database handle
    def setup_citext_type(db)
      citext_metadata = db[:pg_type].where(typname: '_citext')

      if citext_metadata
        citext_oid = citext_metadata.get(:oid)
        citext_soid = citext_metadata.get(:typelem)

        scalar_type_conversion_proc = { citext_soid => ->(s) { s } }

        db.register_array_type('citext',
                               scalar_typecast: :string,
                               type_symbol: :string,
                               typecast_method: :string,
                               oid: citext_oid,
                               type_procs: scalar_type_conversion_proc)

        db.conversion_procs[citext_oid] =
            Sequel::Postgres::PGArray::Creator.new('citext')

      end
    end

    ##
    # Disconnect the passed Sequel connection.
    # @param db [Sequel::Database] database handle
    def disconnect(db)
      db.disconnect if db.kind_of?(Sequel::Database) && db.pool.size > 0
    end
  end
end
