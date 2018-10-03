require 'will_paginate/array'
class ExercisesController < ApplicationController
  before_action :set_exercise, only: [:show, :edit, :update, :destroy]

  # GET /exercises
  # GET /exercises.json
  def index
    elements_filtered
  end

  # GET /exercises/1
  # GET /exercises/1.json
  def show
  end

  # GET /exercises/new
  def new
    @exercise = Exercise.new
    names_grouped_by_series
  end

  # GET /exercises/1/edit
  def edit
    set_exercise
    @elements = @exercise.elements
  end

  # POST /exercises
  # POST /exercises.json
  def create
    @exercise = Exercise.new(exercise_params)
    if elements_present?
      params[:exercise][:element_n].each do |key, val|
        @exercise.elements<<Element.find(val)
      end
    end

    respond_to do |format|
      if @exercise.save
        flash[:info] = 'Exercise was successfully created.'
        format.html { redirect_to exercises_path }
        format.json { render :index, status: :created }
      else
        names_grouped_by_series
        format.html { render :new }
        format.json { render json: @exercise.errors }
      end
    end
  end

  # PATCH/PUT /exercises/1
  # PATCH/PUT /exercises/1.json
  def update
    respond_to do |format|
      if @exercise.update(exercise_params)
        flash[:info] = 'Exercise was successfully updated.'
        format.html { redirect_to @exercise}
        format.json { render :show, status: :ok, location: @exercise }
      else
        format.html { render :edit }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /exercises/1
  # DELETE /exercises/1.json
  def destroy
    @exercise.destroy
    respond_to do |format|
      flash[:success] = 'Exercise was successfully destroyed.'
      format.html { redirect_to exercises_url}
      format.json { head :no_content }
    end
  end

  private

    def elements_present?
      element_n = params.dig(:element_n)
      element_name_length = element_n.to_unsafe_h.all?{ |k,v| v.to_i > 0} if element_n
      exercise_element_n = params.dig(:exercise, :element_n)
      exercise_element_name_length = exercise_element_n.to_unsafe_h.all?{ |k,v| v.to_i > 0} if exercise_element_n
      element_and_length_test = element_n && element_name_length
      exercise_element_and_length_test = exercise_element_n && exercise_element_name_length
      (element_and_length_test) || ( exercise_element_and_length_test) ? true : false
    end

    def elements_filtered
      names_grouped_by_series
      if elements_present?
        query_by_elements
      else
        sorted = Exercise.all.sort_by {|p| p.full_name}
        @exercises = sorted.paginate(page: params[:page], :per_page => 30)
      end
    end

    def query_by_elements(element_ids = params[:element_n])
      id_hash = {}
      element_ids.each do |name, id|
        id_hash[:id] = id
      end
      filtered_exercises = Exercise.joins(:elements).where(:elements => id_hash)
      filtered_and_sorted_exercises = filtered_exercises.sort_by {|p| p.full_name}
      @exercises = filtered_and_sorted_exercises.paginate(page: params[:page], :per_page => 30)
    end

    def names_grouped_by_series
      group_series_element = Element.group('elements.id').group('elements.series_name')
      
      @names_grouped_by_series = group_series_element.map{|p| [p.series_name.prepend(""), Element.where(series_name: p.series_name).map{|element| [element.name, element.id]}.prepend("Select Element")] }
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_exercise
      @exercise = Exercise.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def exercise_params
      params.require(:exercise).permit(:reps_bool,:right_left_bool, :resistance_bool, :duration_bool, :work_rest_bool)
    end
end
