class WelcomeController < ApplicationController

  def login_page
    redirect_to :dashboard if session[:user_token]
  end

  def dashboard

    @projects = @mustard.projects.all
    @teams = @mustard.teams.all

  end
end
