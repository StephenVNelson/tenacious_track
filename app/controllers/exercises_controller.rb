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
  end

  # POST /exercises
  # POST /exercises.json
  def create
    @exercise = Exercise.new(exercise_params)
    params[:exercise][:element_n].each do |key, val|
      @exercise.elements<<Element.find(val)
    end

    respond_to do |format|
      if @exercise.save
        flash[:info] = 'Exercise was successfully created.'
        format.html { redirect_to exercises_path }
        format.json { render :show, status: :created, location: @exercise }
      else
        format.html { render :new }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
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

    def elements_filtered
      names_grouped_by_series
      if params[:element_n] && params[:element_n][:name].length > 0
        query_by_elements
      else
        @exercises = Exercise.all.paginate(page: params[:page], :per_page => 30)
      end
    end

    def query_by_elements(element_ids = params[:element_n])
      id_hash = {}
      element_ids.each do |name, id|
        id_hash[:id] = id
      end
      @exercises = Exercise.joins(:elements).where(:elements => id_hash).paginate(page: params[:page], :per_page => 30)
    end

    def names_grouped_by_series
      @names_grouped_by_series = Element.group(:series_name).map{|p| [p.series_name.prepend(""), Element.where(series_name: p.series_name).map{|thing| [thing.name, thing.id]}.prepend("Select Element")] }
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
