class ProjectsController < ApplicationController


  def index
    @projects = @mustard.projects.all

    if @projects['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to access projects. Error[#{@projects['error']}]"}
    end
  end


  def show
    @project = @mustard.projects.find params[:id]

    if @project['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to access project. Error[#{@project['error']}]"}
    end
  end


  def create

    project = @mustard.projects.add({name: project_params[:name]})
    if project['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to create project. Error[#{project['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Project #{project['project']['name']} created"}
    end
  end


  def update

    # puts create_user_params
    project = @mustard.projects.update(params[:id], {name: project_params[:name]})

    if project['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to update project. Error[#{project['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Project #{project['project']['name']} updated"}
    end
  end


  def destroy
    # puts create_user_params
    project = @mustard.projects.delete(params[:id])

    if project['error']
      redirect_back fallback_location: projects_path, flash: { alert: "Failed to delete project. Error[#{project['error']}]"}
    else
      redirect_to projects_path, flash: { success:  "Project deleted"}
    end
  end

  private

  def project_params
    params.require(:project).permit(:name)
  end

end
