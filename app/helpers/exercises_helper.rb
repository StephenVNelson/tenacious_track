module ExercisesHelper
  def set_element_card_display_width(collection)
    element_count = collection.map{|p| Element.series_list_items(p).count}
    element_count.any?{|p| p <= 3} ? '65%' : '45%'
  end
end
