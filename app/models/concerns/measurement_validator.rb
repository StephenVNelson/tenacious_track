class MeasurementValidator < ActiveModel::Validator
  def validate(record)
    if Exercise.booleans.all? {|attr| record.send(attr) == false}
      record.errors.add(:measurements,'At least one measurement must be selected')
    end
  end
end
