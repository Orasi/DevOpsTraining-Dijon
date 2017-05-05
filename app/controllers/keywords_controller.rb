class KeywordsController < ApplicationController

  def edit
    keyword = @mustard.keywords.find(params[:id])

    if keyword['error']
      render json: {error: "User failed to create. Error[#{keyword['error']}]"}, status: :not_found and return
    else
      @project = (@mustard.projects.find keyword['keyword']['project_id'])
      @selected = keyword['keyword']['testcases'].map{|tc| tc['id']} if keyword['keyword']['testcases']

      render partial: 'keywords/keyword_form', locals: {keyword: KeywordPresenter.new(keyword['keyword']), project_id: keyword['keyword']['project_id']}
    end
  end

  def create
    if params[:testcases] && !params[:testcases].blank?
      keyword = @mustard.keywords.add({ project_id: keyword_params[:project_id],
                                        keyword: keyword_params[:keyword]},
                                      testcase_ids: params[:testcases]
                                      )
    else
      keyword = @mustard.keywords.add({ project_id: keyword_params[:project_id],
                                        keyword: keyword_params[:keyword]
                                      })
    end

    if keyword['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to create keyword. Error[#{keyword['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Keyword #{keyword['keyword']['keyword']} created"}
    end
  end

  def update


    # puts create_user_params
    if params[:testcases] && !params[:testcases].blank?
      keyword = @mustard.keywords.update(params[:id], {project_id: keyword_params[:project_id],
                                                       keyword: keyword_params[:keyword]},
                                                       testcase_ids: params[:testcases]
      )
    else
      keyword = @mustard.keywords.update(params[:id], {project_id: keyword_params[:project_id],
                                                       keyword: keyword_params[:keyword]
      })
    end


    if keyword['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to update team. Error[#{keyword['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Keyword #{keyword['keyword']['keyword']} updated"}
    end
  end

  def destroy
    # puts create_user_params
    keyword = @mustard.keywords.delete(params[:id])

    if keyword['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to delete keyword. Error[#{keyword['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Keyword deleted"}
    end
  end

  private

  def keyword_params
    params.require(:keyword).permit(:project_id, :keyword, :testcase)
  end

end
