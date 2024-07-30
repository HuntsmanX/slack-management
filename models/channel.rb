# frozen_string_literal: true

class Channel < Sequel::Model
  plugin :timestamps
  many_to_one :team
end
