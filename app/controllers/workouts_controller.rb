class WorkoutsController < ApplicationController
  def index
    @workouts = Workout.all
  end

  def show
    @workout = Workout.find(params[:id])
  end

  def new
    @workout = Workout.new
    @client = Client.find(params[:client])
  end

  def create
    @workout = Workout.new(workout_params)
    if @workout.save
      flash[:info] = "Workout created. Now pick a template to start with."
      redirect_to workout_path(@workout)
    else
      flash[:danger] = "didn't work"
      render 'new'
    end
  end

  private

  def workout_params
    params.require(:workout).permit(:phase_number, :week_number, :day_number, :trainer_id, :client_id)
  end
end
