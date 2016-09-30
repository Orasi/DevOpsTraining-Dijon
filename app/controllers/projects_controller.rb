class ProjectsController < ApplicationController

  def index
    @projects = @mustard.projects.all
  end

  def show
    @project = @mustard.projects.find params[:id]
  end
end
