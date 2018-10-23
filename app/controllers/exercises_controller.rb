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
        format.html { redirect_to exercises_path }
        format.json { render :index, status: :created }
      else
        format.html { render :new }
        format.json { render json: @new_exercise.errors }
      end
    end
  end

  # PATCH/PUT /exercises/1
  # PATCH/PUT /exercises/1.json
  def update
    respond_to do |format|
      if @exercise.update(exercise_params)
        flash[:info] = 'Exercise was successfully updated.'
        format.html { redirect_to exercises_path}
        format.json { render :index, status: :created }
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

    def elements_filtered
      @exercises = Exercise.all.paginate(page: params[:page], :per_page => 30)
    end


    # Use callbacks to share common setup or constraints between actions.
    def set_exercise
      @exercise = Exercise.find(params[:id])
    end

    def set_elements
      @elements = Element.all
    end

    def multiselect_present?
      if params[:exercise].key?(:exercise_elements_attributes)
        current_params = params[:exercise][:exercise_elements_attributes]["0"][:element_id]
        current_params.class == Array
      else
        false
      end
    end

    #changes params layout in case multiselect is used
    def reformat_militselect_params_format
      current_params = params[:exercise][:exercise_elements_attributes]
      current_params["0"][:element_id].each_with_index do |element, idx|
        if !element.empty?
          current_params["#{idx+1}"] = {element_id: element}
        end
      end
      current_params.delete("0")
    end

    def exercise_params
      reformat_militselect_params_format unless !multiselect_present?
      params.require(:exercise).permit(
                                      :reps_bool,
                                      :right_left_bool,
                                      :resistance_bool,
                                      :duration_bool,
                                      :work_rest_bool,
                                      exercise_elements_attributes: [:element_id, :id, :_destroy])
    end
end
