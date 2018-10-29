require 'will_paginate/array'
class ExercisesController < ApplicationController
  before_action :set_exercise, only: [:show, :edit, :update, :destroy]
  before_action :set_elements, only: [:show, :edit, :update, :destroy]

  # GET /exercises
  # GET /exercises.json
  def index
    elements_filtered
    @new_exercise = Exercise.new
    @new_exercise.exercise_elements.build
  end

  # GET /exercises/1
  # GET /exercises/1.json
  def show
  end

  # GET /exercises/new
  def new
    @new_exercise = Exercise.new
    @new_exercise.exercise_elements.build
  end

  # GET /exercises/1/edit
  def edit
  end

  # POST /exercises
  # POST /exercises.json
  def create
    @new_exercise = Exercise.new(exercise_params)

    respond_to do |format|
      if @new_exercise.save
        flash[:info] = 'Exercise was successfully created.'
        format.html {redirect_to exercises_path}
        format.json {render :index, status: :created}
      else
        format.html {render :new}
        format.json {render json: @new_exercise.errors}
      end
    end
  end

  # PATCH/PUT /exercises/1
  # PATCH/PUT /exercises/1.json
  def update
    respond_to do |format|
      if @exercise.update(exercise_params)
        flash[:info] = 'Exercise was successfully updated.'
        format.html {redirect_to exercises_path}
        format.json {render :index, status: :created}
      else
        format.html {render :edit}
        format.json {render json: @exercise.errors, status: :unprocessable_entity}
      end
    end
  end

  # DELETE /exercises/1
  # DELETE /exercises/1.json
  def destroy
    @exercise.destroy
    respond_to do |format|
      flash[:success] = 'Exercise was successfully destroyed.'
      format.html { redirect_to exercises_url }
      format.json { head :no_content }
    end
  end

  private

  def elements_filtered
    @exercises = Exercise.element_search(params[:query]).paginate(page: params[:page], per_page: 30)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_exercise
    @exercise = Exercise.find(params[:id])
  end

  def set_elements
    @elements = Element.all
  end

  def multiselect_present?
    params[:exercise].key?(:exercise_elements_attributes) &&
      exercise_elements_params["0"][:element_id].is_a?(Array)
  end

  # changes params layout in case multiselect is used
  def reformat_multiselect_params_format
    # you might be able to just map exercise_elements_params["0"][:element_id]
    # reformatted_params = {}
    # exercise_elements_params["0"][:element_id].map |a|
    #   reformatted_params << { element_id: id }
    # end
    # exercise_elements_params = reformatted_params
    exercise_elements_params["0"][:element_id].each_with_index do |id, idx|
      if id.present?
        exercise_elements_params[(idx + 1).to_s] = { element_id: id }
      end
    end
    exercise_elements_params.delete("0")
  end

  def exercise_params
    reformat_multiselect_params_format if multiselect_present?
    params.require(:exercise).permit(
      :reps_bool,
      :right_left_bool,
      :resistance_bool,
      :duration_bool,
      :work_rest_bool,
      exercise_elements_attributes: [:element_id, :id, :_destroy]
    )
  end

  def exercise_elements_params
    params[:exercise][:exercise_elements_attributes]
  end
end
