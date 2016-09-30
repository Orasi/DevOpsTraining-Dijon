class ExecutionsController < ApplicationController

  def show
    @status = @mustard.executions.testcase_status( params[:id] )
    @summary = @mustard.executions.environment_summary( params[:id])

  end

  def testcase_detail

    @detail = @mustard.executions.testcase_detail(params[:id], params[:testcase_id])
    render partial: 'executions/functional/functional_result', layout: false

  end
end
