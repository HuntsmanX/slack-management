# frozen_string_literal: true

class Team < Sequel::Model
  plugin :timestamps
  many_to_one :business_unit
  one_to_many :channels
end
