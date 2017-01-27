class UsersController < ApplicationController

  skip_before_action :require_user_token, only: [:trigger_password_reset, :reset_password, :reset_password_form, :forgot_password]

  def index

    @users = @mustard.users.all

    if @users['error']
      redirect_to user_path(current_user['id'])
    end

  end

  def show
    user = @mustard.users.find(params[:id])
    @user = UserPresenter.new(user['user'])

    if user['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to access user. Error[#{user['error']}]"}
    end
  end

  def create

    redirect_back(fallback_location: root_path) and return unless params[:user][:password] == params[:user][:password_confirmation]
    # puts create_user_params
    user = @mustard.users.add({first_name: create_user_params[:first_name],
                               last_name: create_user_params[:last_name],
                               company: create_user_params[:company],
                               username: create_user_params[:username],
                               email: create_user_params[:email],
                               password: create_user_params[:password],
                               admin: create_user_params[:admin]
                              })
    if user['error']
      redirect_back fallback_location: root_path, flash: { notice: "User failed to create. Error[#{user['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "User #{user['user']['username']} created"}
    end
  end

  def update

    # puts create_user_params
    user = @mustard.users.update(params[:id], {first_name: update_user_params[:first_name],
                                               last_name: update_user_params[:last_name],
                                               company: update_user_params[:company],
                                               username: update_user_params[:username],
                                               admin: update_user_params[:admin]
                                              })
    if user['error']
      redirect_back fallback_location: root_path, flash: { notice: "User failed to update. Error[#{user['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "User #{user['user']['username']} updated"}
    end
  end

  def destroy
    # puts create_user_params
    user = @mustard.users.delete(params[:id])

    if user['error']
      redirect_back fallback_location: root_path, flash: { notice: "User failed to delete. Error[#{user['error']}]"}
    else
      redirect_to users_path, flash: { success:  "User deleted"}
    end
  end

  def trigger_password_reset
    user = @mustard.users.find(params[:id])
    @user = UserPresenter.new(user['user'])

    if user['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to access user. Error[#{user['error']}]"}
    end

    @mustard.users.trigger_password_reset( @user.username,reset_password_form_url(@user.id, token: 'TOKEN'))
    redirect_back fallback_location: root_path, flash: {success: "Password reset email sent for user #{@user['username']}"}
  end


  def forgot_password
    user = @mustard.users.find_by_username(params[:email])
    @user = UserPresenter.new(user['user'])

    unless user['error']
      @mustard.users.trigger_password_reset(@user['email'], reset_password_form_url(@user.id, token: 'TOKEN'))
    end

    redirect_back fallback_location: root_path, flash: {success: "Password reset email sent for user #{params['username']}"}
  end

  def reset_password_form

    @user_id = params[:id]
    @token = params[:token]

  end

  def reset_password

    redirect_back fallback_location: root_path, flash: {alert: 'Passwords do not match'} and
        return unless params[:password] == params[:password_confirmation]

    response = @mustard.users.reset_password params[:user_id], params[:password_token], params[:password]

    if response['error']
      redirect_back fallback_location: root_path, flash: { alert: response['error']}
    else
      redirect_to root_path, flash: { success: 'Password Changed'}
    end
  end

  private

  def update_user_params
    params.require(:user).permit(:first_name, :last_name, :company, :username, :admin, :email)
  end

  def create_user_params
    params.require(:user).permit(:first_name, :last_name, :company, :username,  :password, :admin, :email)
  end
end
