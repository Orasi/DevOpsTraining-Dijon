class ExecutionsController < ApplicationController


  def edit
    execution = @mustard.executions.find(params[:id])
    project = @mustard.projects.find(execution['execution']['project_id'])
    @keywords = project['project']['keywords']
    @environments = project['project']['environments']
    if execution['error']
      render json: {error: "Failed to find execution. Error[#{execution['error']}]"}, status: :not_found and return
    else
      render partial: 'executions/edit_execution', locals: {execution: execution, execution_id: execution['execution']['id']}
    end
  end

  def update
    update_params = {}
    update_params[:name] = params[:execution][:name] if params[:execution][:name]
    update_params[:fast] = params[:execution][:fast] if params[:execution][:fast]

    update_params[:limit_environments] = params[:execution][:edit_environments] == 'true'
    if params[:execution][:edit_keywords]
      update_params[:active_environments] = params[:edit_active_environments]
    else
      update_params[:active_environments] = nil
    end

    update_params[:limit_keywords] = params[:execution][:edit_keywords] == 'true'
    if params[:execution][:edit_keywords]
      update_params[:active_keywords] = params[:edit_active_keywords]
    else
      update_params[:active_keywords] = nil
    end
    execution = @mustard.executions.update(params[:id], update_params)
    puts update_params
    redirect_to project_path(execution['execution']['project_id'])
  end


  def show

    @status = @mustard.executions.testcase_status( params[:id] )
    @execution = @mustard.executions.find(params[:id])

  end


  def testcase_detail

    @detail = @mustard.executions.testcase_detail(params[:id], params[:testcase_id])
    @execution = @mustard.executions.find(params[:id])
    @environments = @execution['execution']
    render partial: 'executions/functional/functional_result', layout: false

  end


  def environment_overview

    @count = @mustard.executions.testcase_count( params[:id])
    @execution = @mustard.executions.find( params[:id] )
    @summary = @mustard.executions.environment_summary( params[:id])

    render partial: 'executions/environment_overview', locals: {summary: @summary['summary'], environments: @execution['execution']['environments']}

  end


  def testcase_overview

    @count = @mustard.executions.environment_count( params[:id])
    @execution = @mustard.executions.find( params[:id] )
    @summary = @mustard.executions.testcase_summary( params[:id])

    render partial: 'executions/testcase_overview', locals: {summary: @summary['summary'], testcases: @execution['execution']['testcases']}
    
  end
  
  def keyword_overview

    @execution = @mustard.executions.find(params[:id])['execution']
    @summary = @mustard.executions.keyword_summary( params[:id])

    render partial: 'executions/keyword_overview', locals: {execution: @execution, summary: @summary['summary']}

  end


  def close
    new_execution_params = {name: params[:execution][:name], active_keywords: params[:active_keywords], active_environments: params[:active_environments], fast: params[:execution][:fast]}
    execution = @mustard.executions.close(execution_id: params[:id], new_execution_params: new_execution_params)

    if execution['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to close execution. Error[#{execution['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Execution closed"}
    end

  end


  def destroy

    execution = @mustard.executions.delete(params[:id])

    if execution['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to delete execution. Error[#{execution['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Execution deleted"}
    end

  end


  def project_summary(update=false)

    @title = params[:title]

    render partial: 'projects/no_execution_status' and return if params[:id] == '-1'

    @status = @mustard.executions.testcase_status( params[:id] )
    render partial: 'projects/execution_status', locals: {execution: @status['execution'], update: update}

  end


  def project_summary_update
    project_summary(true)
  end


  def result_history

    @result = @mustard.results.find(params[:id])

    render json: {error: 'Could not find result'} and return unless @result

    render partial: 'executions/functional/result_history', locals: {results: @result['result'], display_environment: false}

  end


  def next_test

    @execution = @mustard.executions.find(params[:id])
    if !@execution['execution']['fast'] && !params[:environment]
      @environments = @execution['execution']
      if cookies[:last_environment]
        @selected = YAML::load cookies[:last_environment]
      end
      render partial: 'executions/select_environment', locals: {execution_id: params[:id]} and return
    end

    params[:keyword] = params[:keyword].map{|m| m.split(',')}.flatten if params[:keyword]

    if params[:keyword] && !params[:keyword].blank? && params[:environment] && !params[:environment].blank?
      next_test = @mustard.executions.next_test(params[:id], keywords: params[:keyword], environment: params[:environment])
    elsif params[:keyword] && !params[:keyword].blank?
      next_test = @mustard.executions.next_test(params[:id], keywords: params[:keyword])
    elsif params[:environment] && !params[:environment].blank?
      next_test = @mustard.executions.next_test(params[:id], environment: params[:environment])
    else
      next_test = @mustard.executions.next_test(params[:id])
    end
    puts next_test['error']
    render partial: 'results/error_loading', flash: { alert: "Failed to get next test. Error #{next_test['error']}"} and return if next_test['error']

    @execution_id = params[:id]

    cookies[:last_environment] = params[:environment] if params[:environment]

    if cookies[:last_environment]
      @selected = YAML::load cookies[:last_environment]
    end


    @environments = @execution['execution']
    if next_test['testcase']['id']
      @keywords = @execution['execution']
      render partial: 'results/manual_test_runner', locals: {testcase: next_test['testcase'], keyword: params[:keyword]}
    else
      @keywords = @execution['execution']
      render partial: 'results/no_testcases', locals: { keyword: params[:keyword], execution_id: @execution_id } and return unless next_test['testcase']['id']
    end

  end

end
