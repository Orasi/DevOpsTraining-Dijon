class TeamsController < ApplicationController

  def index
    @teams = @mustard.teams.all
  end

  def show
    @team = @mustard.teams.find params[:id]

    redirect_back fallback_location: root_path, flash: { alert: @team['error']} if @team['error']
  end
end
