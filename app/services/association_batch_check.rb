class AssociationBatchCheck
  def initialize(object = nil, associations)
    @object = object
    @associations = associations
  end

  def multiselect_present?
    @associations["0"].present? && @associations["0"][:element_id].is_a?(Array)
  end

  # changes params layout in case multiselect is used
  def reformat_multiselect_params_format
    params = @associations["0"][:element_id]
    params.each_with_index do |id, idx|
      @associations[(idx + 1).to_s] = { element_id: id, "_destroy" => "0" } if id.present?
    end
    @associations.delete("0")
  end

  def convert_params
    reformat_multiselect_params_format if multiselect_present?
    @associations
  end

  def pending_associations
    reformat_multiselect_params_format if multiselect_present?
    thing = []
    @associations.each do |k, v|
      thing << v["element_id"].to_i if v["_destroy"] == "0"
    end
    thing.sort
  end

  def valid?
    all_exercises_but = Exercise.where.not(id: @object.id).map {|e| e.element_ids.sort}
    if !all_exercises_but.include?(pending_associations)
      @object.full_name(pending_associations)
      true
    else
      @object.errors[:base] << "Did not save because an identical exercise already exists."
      false
    end
  end
end
