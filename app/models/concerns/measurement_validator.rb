class MeasurementValidator < ActiveModel::Validator
  def validate(record)
    if Exercise.booleans.all? {|attr| record.send(attr).nil?}
      record.errors.add("Error:",' At least one measurement must be selected')
    end
  end
end


# @@accept_array = [:reps_bool , :right_left_bool , :resistance_bool , :duration_bool , :work_rest_bool]
# def measurement_presence
#   if @@accept_array.all?{|attr| attr.nil?}
#     errors.add("You", "must select a measurement method")
#   end
# end
