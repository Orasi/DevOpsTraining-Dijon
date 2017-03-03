class ExecutionsController < ApplicationController



  def show

    @status = @mustard.executions.testcase_status( params[:id] )

  end


  def testcase_detail

    @detail = @mustard.executions.testcase_detail(params[:id], params[:testcase_id])
    @environments = @mustard.projects.environments(@detail['testcase']['project_id'])
    render partial: 'executions/functional/functional_result', layout: false

  end


  def environment_overview

    @count = @mustard.executions.testcase_count( params[:id])
    @summary = @mustard.executions.environment_summary( params[:id])

    render partial: 'executions/environment_overview', locals: {execution: @summary['summary']}

  end


  def testcase_overview

    @count = @mustard.executions.environment_count( params[:id])
    @summary = @mustard.executions.testcase_summary( params[:id])
    puts @summary

    render partial: 'executions/testcase_overview', locals: {execution: @summary['summary']}

  end


  def close

    execution = @mustard.executions.close(execution_id: params[:id], name: params[:execution][:name])

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

    next_test = @mustard.executions.next_test(params[:id])

    redirect_back fallback_location: root_path, flash: { alert: "Failed to get next test"} and return if next_test['error']

    @execution_id = params[:id]
    if cookies[:last_environment]
      @selected = YAML::load cookies[:last_environment]
    end

    if next_test['testcase']['id']
      @environments = @mustard.projects.environments(next_test['testcase']['project_id'])
      render partial: 'results/manual_test_runner', locals: {testcase: next_test['testcase']}
    else
      render partial: 'results/no_testcases' and return unless next_test['testcase']['id']
    end

  end

end
