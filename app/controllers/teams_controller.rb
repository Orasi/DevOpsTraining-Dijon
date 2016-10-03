class TeamsController < ApplicationController

  def index

    @teams = @mustard.teams.all
    redirect_back fallback_location: root_path, flash: { alert: @teams['error']} if @teams['error']

  end

  def show

    @team = @mustard.teams.find params[:id]
    @users = @mustard.users.all
    @projects = @mustard.projects.all

    redirect_back fallback_location: root_path, flash: { alert: @team['error']} if @team['error']

  end

  def create

    team = @mustard.teams.add({name: team_params[:name],
                               description: team_params[:description]
                               })
    if team['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to create team. Error[#{team['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "team #{team['team']['name']} created"}
    end
  end

  def update

    # puts create_user_params
    team = @mustard.teams.update(params[:id], {name: team_params[:name],
                                               description: team_params[:description]
    })

    if team['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to update team. Error[#{team['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Team #{team['team']['name']} updated"}
    end
  end

  def destroy
    # puts create_user_params
    team = @mustard.teams.delete(params[:id])

    if team['error']
      redirect_back fallback_location: teams_path, flash: { alert: "Failed to delete team. Error[#{team['error']}]"}
    else
      redirect_to teams_path, flash: { success:  "Team deleted"}
    end
  end


  def add_user

    @team = @mustard.teams.add_user(params[:id], params[:team][:user_id])
    if @team['error']
      redirect_back fallback_location: teams_path, flash: { alert: "Failed to add user to team. Error[#{@team['error']}]"}
    else
      redirect_back fallback_location: teams_path, flash: { success: "User Added"}
    end


  end


  def add_project
    @team = @mustard.teams.add_project(params[:id], params[:team][:project_id])
    if @team['error']
      redirect_back fallback_location: teams_path, flash: { alert: "Failed to add project to team. Error[#{@team['error']}]"}
    else
      redirect_back fallback_location: teams_path, flash: { success: "Project Added"}
    end

  end


  def remove_user

    @team = @mustard.teams.remove_user(params[:id], params[:user_id])

    if @team['error']
      redirect_back fallback_location: teams_path, flash: { alert: "Failed to remove user from team. Error[#{@team['error']}]"}
    else
      redirect_back fallback_location: teams_path, flash: { success: "User Removed"}
    end

  end

  def remove_project

    @team = @mustard.teams.remove_project(params[:id], params[:project_id])

    if @team['error']
      redirect_back fallback_location: teams_path, flash: { alert: "Failed to remove project from team. Error[#{@team['error']}]"}
    else
      redirect_back fallback_location: teams_path, flash: { success: "Project Removed"}
    end

  end

  private

  def team_params
    params.require(:team).permit(:name, :description)
  end
end
