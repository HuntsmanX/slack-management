# frozen_string_literal: true

class AddBusinessUnit
  include Strum::Service

  def call
    busisness_unit = BusinessUnit.new(name: unit_name)
    if busisness_unit.valid?
      busisness_unit.save
      puts "Business Unit created: #{unit_name}"
    else
      add_errors(busisness_unit.errors)
    end
  end

  def audit
    sliced(:unit_name)
    required(:unit_name)
  end
end

