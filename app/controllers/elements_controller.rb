class ElementsController < ApplicationController
  require 'will_paginate/array'
  before_action :logged_in_user, only: [:index, :import, :new, :edit]
  before_action :admin_user,     only: [:create, :edit, :update, :new, :destroy]

  def index
    @all_elements = Element.all
    @new_element = Element.new
    @series = params[:series] || ""
    filter_results
  end

  def new
    @element = Element.new
  end

  def create
    filter_results
    @new_element = Element.new(element_params)
    if @new_element.save
      flash[:info] = "Exercise element successfully added"
      redirect_to elements_path
    else
      render 'index'
    end
  end

  def edit
    @new_element = Element.find(params[:id])
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
    flash[:success] = "Element deleted"
    redirect_to elements_path(series: @series)
  end

  private

    def element_params
      params.require(:element).permit(:element_category_id, :name)
    end

    def filter_results
      @elements = Element.text_search(params[:query]).paginate(page: params[:page], :per_page => 15)
    end
end
