# frozen_string_literal: true

require "sequel/model"
module Seeds
  class Teams
    class Team < Sequel::Model; end
    class BusinessUnit < Sequel::Model; end

    Teams = [
      { name: "General" },
      { name: "SSO" },
      { name: "User Management" },
      { name: "Labor Office" },
      { name: "Visa" },
      { name: "Certificates" },
      { name: "Occupation Management" },
      { name: "E Services" }
    ].freeze

    def run
      Teams.each do |attributes|
        existing_record = Team.find(name: attributes[:name])

        create_record(attributes) unless existing_record&.id
      end
    end

    def create_record(attributes)
      attributes[:created_at] = Time.now
      attributes[:business_unit_id] = BusinessUnit.find(name: "Qiwa").id
      Team.create(attributes)
    end
  end
end
