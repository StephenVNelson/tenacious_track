module ElementsHelper
  def element_category(category_id)
    ElementCategory.find(category_id).category_name
  end
end
