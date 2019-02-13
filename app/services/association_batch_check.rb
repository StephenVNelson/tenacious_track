class AssociationBatchCheck
  def initialize(object, associations)
    @object = object
    @associations = associations
  end

  def pending_associations
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
      @object.errors[:base] << "Edits did not save because an identical exercise already exists."
      false
    end
  end
end
