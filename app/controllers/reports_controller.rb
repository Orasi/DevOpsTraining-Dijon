class ReportsController < ApplicationController


  def testcase_status_form

    project = @mustard.projects.find(params[:project_id])

    redirect_back fallback_location: root_path, flash: { alert: 'An unknown error occured'} and return unless project
    redirect_back fallback_location: root_path, flash: { alert: @project['error']} and return if project['error']

    @project = project['project']

    render :testcase_status_form, layout: false

  end


  def testcase_status
    @project = @mustard.projects.find(params[:project_id])

    redirect_back fallback_location: root_path, flash: { alert: @project['error']} and return if @project['error']

    @result = @mustard.executions.testcase_status(params[:execution_id], 'xlsx')

    redirect_back fallback_location: root_path, flash: { alert: @result['error']} and return if @result['error']

    redirect_to @result['report']
  end


end
