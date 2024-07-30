# frozen_string_literal: true

Sequel.migration do
  change do
    extension(:constraint_validations)
    create_table(:channels) do
      primary_key :id, Integer
      foreign_key :team_id, :teams
      column :channel_id, String, unique: true
      column :name, String
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
