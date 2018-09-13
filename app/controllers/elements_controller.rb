class ElementsController < ApplicationController
  before_action :logged_in_user, only: [:index, :import, :new, :edit]

  def index
    @series = params[:series] || ""
    filter_results
  end

  def import
    Element.import(params[:file])
    # after the import, redirect and let us know the method worked!
    redirect_to root_url, notice: "Activity Data imported!"
  end

  def new
    @element = Element.new
  end

  def create
    @element = Element.new(element_params)
    if @element.save
      flash[:info] = "Exercise element successfully added"
      redirect_to elements_path
    else
      render 'new'
    end
  end

  def edit
    @element = Element.find(params[:id])
  end

  def update
    @element = Element.find(params[:id])
    if @element.update_attributes(element_params)
      flash[:success] = "Profile updated"
      redirect_to elements_path
    else
      render 'edit'
    end
  end

  def destroy
    @series = params[:series]
    Element.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to elements_path(series: @series)
  end

  private

    def element_params
      params.require(:element).permit(:series_name, :name)
    end

    def filter_results
      if params[:series] && params[:series].length > 0
        @elements = Element.where(series_name: params[:series]).paginate(page: params[:page], :per_page => 15)
      else
        @elements = Element.paginate(page: params[:page], :per_page => 15)
      end
    end
end
