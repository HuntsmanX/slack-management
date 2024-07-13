# frozen_string_literal: true

Sequel.migration do
  change do
    extension(:constraint_validations)
    create_table(:business_units) do
      primary_key :id, Integer
      column :name, String, unique: true
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
