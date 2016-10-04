require 'MustardClient'
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :require_user_token, except: [:login_page, :login]
  before_action :attach_mustard_client
  helper_method :current_user

  rescue_from MustardClient::SessionExpiredError, with: :wipe_session

  def wipe_session
    puts 'Session Expired:  Clearing Session Cache'
    session[:current_user] = nil
    session[:user_token] = nil
    redirect_to :login
  end

  def current_user
    if session[:current_user]
      return CurrentUserPresenter.new(session[:current_user])
    else
      return nil
    end

  end

  def attach_mustard_client
    @mustard = MustardClient::Mustard.new
    @mustard.set_mustard_url(Rails.application.config.mustard_api)
    @mustard.set_user_token(session[:user_token])
  end


  def require_user_token
    unless session[:user_token]
      session[:user] = nil
      redirect_to :login unless session[:user_token]
    end

  end

  def login_page
    render 'welcome/login_page'
  end

  def login
    r = @mustard.authenticate(params[:username], params[:password])

    redirect_to :login and return if r['error']
    session[:current_user] = r
    session[:user_token] = r['token']

    redirect_to :dashboard
  end


  def logout
    session[:user_token] = nil
    redirect_to '/login'
  end

end
