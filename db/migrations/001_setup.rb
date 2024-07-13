# frozen_string_literal: true

Sequel.migration do
  up do
    DB.extension(:constraint_validations)
    DB.extension(:pg_array)
    DB.extension(:pg_json)
    DB.create_constraint_validations_table
    extension :date_arithmetic
    run "CREATE EXTENSION IF NOT EXISTS citext;"
  end

  down do
    DB.extension(:constraint_validations)
    DB.drop_constraint_validations_table
  end
end
