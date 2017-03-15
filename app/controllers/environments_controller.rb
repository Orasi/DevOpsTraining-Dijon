class EnvironmentsController < ApplicationController

  def edit
    environment = @mustard.environments.find(params[:id])

    if environment['error']
      render json: {error: "User failed to create. Error[#{environment['error']}]"}, status: :not_found and return
    else
      render partial: 'environments/environment_form', locals: {environment: EnvironmentPresenter.new(environment['environment']), project_id: environment['environment']['project_id']}
    end
  end

  def create

    environment = @mustard.environments.add({uuid: environment_params[:uuid],
                                             project_id: environment_params[:project_id],
                                             display_name: environment_params[:display_name],
                                             environment_type: environment_params[:environment_type]
                                            })

    if environment['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to create environment. Error[#{environment['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Environment #{environment['environment']['uuid']} created"}
    end
  end

  def update

    # puts create_user_params
    environment = @mustard.environments.update(params[:id], {uuid: environment_params[:uuid],
                                                             project_id: environment_params[:project_id],
                                                             display_name: environment_params[:display_name],
                                                             environment_type: environment_params[:environment_type]
    })

    if environment['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to update team. Error[#{environment['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Environment #{environment['environment']['uuid']} updated"}
    end
  end

  def destroy
    # puts create_user_params
    environment = @mustard.environments.delete(params[:id])

    if environment['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to delete environment. Error[#{environment['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Environment deleted"}
    end
  end

  private

  def environment_params
    params.require(:environment).permit(:uuid, :environment_type, :display_name, :project_id)
  end

end
