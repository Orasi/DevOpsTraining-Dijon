class UsersController < ApplicationController

  def index
    @users = @mustard.users.all
  end

  def show
    user = @mustard.users.find(params[:id])
    @user = UserPresenter.new(user['user'])
  end

  def create

    redirect_back(fallback_location: root_path) and return unless params[:user][:password] == params[:user][:password_confirmation]
    # puts create_user_params
    user = @mustard.users.add({first_name: create_user_params[:first_name],
                               last_name: create_user_params[:last_name],
                               company: create_user_params[:company],
                               username: create_user_params[:username],
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

  private

  def update_user_params
    params.require(:user).permit(:first_name, :last_name, :company, :username, :admin)
  end

  def create_user_params
    params.require(:user).permit(:first_name, :last_name, :company, :username,  :password, :admin)
  end
end
