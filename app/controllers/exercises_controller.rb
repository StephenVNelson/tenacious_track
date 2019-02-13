require 'will_paginate/array'
class ExercisesController < ApplicationController
  before_action :set_exercise, only: [:show, :edit, :update, :destroy]
  before_action :set_elements, only: [:show, :edit, :update, :destroy]

  def index
    elements_filtered
    @new_exercise = Exercise.new
    @new_exercise.exercise_elements.build
  end

  def autocomplete
    @exercises = Exercise.search_by_exercise_reps_bool(params[:term])
    render json: @exercises.map {|exercise| {id: exercise.id, value: exercise.name}}
  end

  def show
  end

  def new
    @new_exercise = Exercise.new
    @new_exercise.exercise_elements.build
  end

  def edit
  end

  # TODO: Make it so it returns back to the page it just came from after you create a new exercise
  def create
    @new_exercise = Exercise.new(exercise_params)
    valid_associations = AssociationBatchCheck.new(@new_exercise, exercise_elements_params).valid?
    respond_to do |format|
      if valid_associations && @new_exercise.save
        flash[:info] = 'Exercise was successfully created.'
        format.html {redirect_to exercises_path}
        format.json {render :index, status: :created}
      else
        format.html {render :new}
        format.json {render json: @new_exercise.errors}
      end
    end
  end

  def update
    valid_association = AssociationBatchCheck.new(@exercise, exercise_elements_params).valid?
    respond_to do |format|
      if valid_association && @exercise.update(exercise_params)
        flash[:info] = 'Exercise was successfully updated.'
        format.html {redirect_to exercises_path}
        format.json {render :index, status: :created}
      else
        # flash[:danger] = @exercise.errors.full_messages.join(", ")
        format.html {render 'exercises/edit'}
        format.json {render json: @exercise.errors, status: :unprocessable_entity}
      end
    end
  end

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

  def exercise_params
    exercise_elements_params
    params.require(:exercise).permit(
      :reps_bool,
      :right_left_bool,
      :resistance_bool,
      :duration_bool,
      :work_rest_bool,
      :name,
      exercise_elements_attributes: [:element_id, :id, :_destroy]
    )
  end

  def exercise_elements_params
    original_params = params[:exercise][:exercise_elements_attributes]
    original_params = AssociationBatchCheck.new(original_params).convert_params
  end
end
