# frozen_string_literal: true

Sequel.migration do
  change do
    extension(:constraint_validations)
    create_table(:teams) do
      primary_key :id, Integer
      foreign_key :business_unit_id, :business_units
      column :name, String, unique: true
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
