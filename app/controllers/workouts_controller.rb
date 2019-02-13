class WorkoutsController < ApplicationController
  def index
    @workouts = Workout.all
  end

  def show
    @workout = Workout.find(params[:id])
    @execution = Execution.new
  end

  def select_client
    @clients = Client.order_by_scheduled_workouts
  end

  def select_template
    @workout = Workout.find(params[:workout])
  end

  def new
    @workout = Workout.new
    @client = Client.find(params[:client])
  end

  def create
    @workout = Workout.new(workout_params)
    @client = Client.find(params[:workout][:client_id])
    if @workout.save
      flash[:info] = "Workout created. Now pick a template to start with."
      redirect_to select_workout_template_path(@workout)
    else
      render :new, location: new_workout_url(@client)
    end
  end

  private

  def workout_params
    params.require(:workout).permit(:phase_number, :week_number, :day_number, :client_id, :scheduled_date)
  end
end
