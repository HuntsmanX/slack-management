# frozen_string_literal: true

class BusinessUnit < Sequel::Model
  plugin :timestamps
  one_to_many :teams
end
