class ExecutionsController < ApplicationController
  before_action :logged_in_user, only: [:new, :create, :edit, :update, :destroy]

  def new
    @execution = Execution.new
  end

  def create
    @execution = Execution.new(execution_params)
    respond_to do |format|
      format.js
      format.html
    end
  end

  def edit
  end

  def destroy
  end

  private

  def execution_params
    params.require(:execution).permit(
      :execution_category,
      :exercise,
      :workout,
      :sets,
      :reps,
      :resistance,
      :seconds
    )
  end
end
