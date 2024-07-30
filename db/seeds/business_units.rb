# frozen_string_literal: true

require "sequel/model"
module Seeds
  class BusinessUnits
    class BusinessUnit < Sequel::Model; end

    BUSINESS_UNIT = [
      { name: "Qiwa" }
    ].freeze

    def run
      BUSINESS_UNIT.each do |attributes|
        existing_record = BusinessUnit.find(name: attributes[:name])

        create_record(attributes) unless existing_record&.id
      end
    end

    def create_record(attributes)
      attributes[:created_at] = Time.now

      BusinessUnit.create(attributes)
    end
  end
end
