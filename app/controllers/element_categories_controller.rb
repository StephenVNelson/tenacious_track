class ElementCategoriesController < ApplicationController

  def index
    @element_categories = ElementCategory.order(:sort).all
    @new_category = ElementCategory.new
  end
  
  def create
    @element_categories = ElementCategory.order(:sort).all
    @new_category = ElementCategory.new(category_params)
    if @new_category.save
      flash[:info] = "Element category successfully added"
      redirect_to element_categories_path
    else
      render 'index'
    end
  end

  def edit
    @element_category = ElementCategory.find(params[:id])
    @name = @element_category.category_name
  end

  def update
    @element_category = ElementCategory.find(params[:id])
    if @element_category.update_attributes(category_params)
      flash[:success] = "Category updated"
      redirect_to element_categories_path
    else
      render 'edit'
    end
  end

  def destroy
    ElementCategory.find(params[:id]).destroy
    flash[:success] = "Category deleted"
    redirect_to element_categories_path
  end

  private

  def category_params
    params.require(:element_category).permit(:category_name, :sort)
  end
end
