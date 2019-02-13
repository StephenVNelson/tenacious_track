class ExecutionsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @workout = Workout.find(params[:id])
    @execution = Execution.new
  end

  def create
    @workout = Workout.find(execution_params[:workout_id])
    @execution = Execution.new(execution_params)
    respond_to do |format|
      if @execution.save
        format.html {redirect_to @workout}
        format.json {render :index, status: :created}
      else
        format.html {render @workout}
        format.json {render json: @execution.errors}
      end
    end
  end

  def edit
  end

  def destroy
  end

  private

  def execution_params
    params.require(:execution).permit(
      :execution_category_id,
      :exercise_id,
      :workout_id,
      :sets,
      :reps,
      :resistance,
      :seconds
    )
  end
end
