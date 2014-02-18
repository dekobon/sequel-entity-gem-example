# Encoding: utf-8

require 'time'
require_relative '../../lib/entities/database'

MIGRATIONS_DIR = File.absolute_path(
    File.join(File.dirname(__FILE__), '../../db/migrate'))

# Snagged from https://gist.github.com/viking/1133150
#
# Some convienent rake tasks for bootstrapping databases
# Using the standalone `sequel` gem

namespace :bundler do
  task :setup do
    require 'rubygems'
    require 'bundler/setup'
  end
end

namespace :db do
  namespace :generate do
    desc 'Generate a timestamped, empty Sequel migration.'
    task :migration, :name do |_, args|
      if args[:name].nil?
        puts 'You must specify a migration name (e.g. rake generate:migration[create_events])!'
        exit false
      end

      content = "Sequel.migration do\n  up do\n    \n  end\n\n  down do\n    \n  end\nend\n"
      timestamp = DateTime.now.strftime("%Y%m%d%H%M%S")
      filename = File.join(MIGRATIONS_DIR,
                           "#{timestamp}_#{args[:name]}.rb")

      File.open(filename, 'w') do |f|
        f.puts content
      end

      puts "Created the migration #{filename}"
    end
  end

  desc 'Run database migrations'
  task :migrate do
    Database.db_setup(single_threaded: true) do |db|
      require 'sequel/extensions/migration'
      Sequel::Migrator.apply(db, MIGRATIONS_DIR)
    end
  end

  desc 'Create database'
  task :create do
    if environment == 'production'
      puts 'DB drop will not work with production environments as a ' +
               'safety precaution'
      return
    end

    db_config = Database.database_config[environment]

    check_for_utility 'createdb'

    db_params = "-h #{db_config['host']} -p #{db_config['port']} " +
        "#{db_config['database']}"

    puts 'Dropping database'
    cmd = "createdb #{db_params}"

    puts cmd
    system cmd
  end

  desc 'Drop database'
  task :drop do
    if environment == 'production'
      puts 'DB drop will not work with production environments as a ' +
               'safety precaution'
      return
    end

    db_config = Database.database_config[environment]

    check_for_utility 'dropdb'

    db_params = "-h #{db_config['host']} -p #{db_config['port']} " +
        "#{db_config['database']}"

    puts 'Dropping database'
    cmd = "dropdb #{db_params}"

    puts cmd
    system cmd
  end

  desc 'Reset the database'
  task :reset => [:drop, :create, :migrate]
end


def check_for_utility(util)
  unless which util
    msg = "Unable to execute task because of missing executable: #{util}"
    fail msg
  end
end
