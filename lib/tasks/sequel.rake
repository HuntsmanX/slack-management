# frozen_string_literal: true

namespace :sequel do # rubocop:disable Metrics/BlockLength
  require "sequel"
  Sequel.extension :migration

  def postgres_cmd
    postgres_db = Sequel.connect(adapter: "postgres",
                                 host: ENV.fetch("DATABASE_HOST", "localhost"),
                                 database: "postgres",
                                 user: ENV.fetch("DATABASE_USER", "postgres"),
                                 password: ENV.fetch("DATABASE_PASSWORD", nil))
    yield(postgres_db)
    postgres_db.disconnect
  end

  desc "Drop database"
  task :drop do
    postgres_cmd do |db|
      db.execute "DROP DATABASE IF EXISTS \"#{ENV.fetch('DATABASE_NAME')}\""
      puts "Database #{ENV.fetch('DATABASE_NAME')} dropped"
    end
  end

  desc "Create database"
  task :create do
    postgres_cmd do |db|
      if db.execute("select datname from pg_database where datname = '#{ENV.fetch('DATABASE_NAME')}';").zero?
        db.execute "CREATE DATABASE \"#{ENV.fetch('DATABASE_NAME')}\""
        puts "Database #{ENV.fetch('DATABASE_NAME')} created"
      else
        puts "Database #{ENV.fetch('DATABASE_NAME')} already exist"
      end
    end
  end

  desc "Reset database"
  task :reset do
    Rake::Task["sequel:drop"].execute
    Rake::Task["sequel:create"].execute
    Rake::Task["sequel:migrate"].execute
  end

  desc "Setup database"
  task :setup do
    Rake::Task["sequel:create"].execute
    Rake::Task["sequel:migrate"].execute
  end

  desc "Prints current schema version"
  task :version do
    require "config/sequel"
    version = if DB.tables.include?(:schema_migrations) && DB[:schema_migrations].count.positive?
                DB[:schema_migrations].order(:filename).last[:filename]
              end || 0

    puts "Current schema version: #{version}"
  end

  desc "Migrate database"
  task :migrate, [:version] do |_t, args|
    require "config/sequel"
    require "logger"
    Sequel.extension :migration
    DB.loggers << Logger.new($stdout) if DB.loggers.empty?
    Sequel::TimestampMigrator.apply(DB, File.join(ENV.fetch("STRUM_ROOT", nil), "db/migrations"), args.version)
  end

  desc "Rollback database"
  task :rollback do
    require "config/sequel"
    Rake::Task["sequel:version"].execute
    if DB[:schema_migrations].count > 1
      prev_version = DB[:schema_migrations]
                     .order(Sequel.desc(:filename))
                     .limit(2)
                     .all
                     .last[:filename]
      target = prev_version.split("_").first.to_i
    end

    Rake::Task["sequel:migrate"].invoke(target || 0)
    Rake::Task["sequel:version"].execute
  end
end
