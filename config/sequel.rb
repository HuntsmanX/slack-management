# frozen_string_literal: true

require "sequel"

DB = Sequel.connect adapter: "postgres",
                    host: ENV.delete("DATABASE_HOST") || "localhost",
                    database: ENV.delete("DATABASE_NAME"),
                    user: ENV.delete("DATABASE_USER"),
                    password: ENV.delete("DATABASE_PASSWORD"),
                    port: ENV.delete("DATABASE_PORT"),
                    max_connections: ENV.fetch("MAX_CONNECTIONS", 4),
                    pool_timeout: ENV.fetch("POOL_TIMEOUT", 5)
DB.extension(:pg_enum, :pg_array, :pg_json, :pagination)
