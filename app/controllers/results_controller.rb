class ResultsController < ApplicationController

  def show
    @result = @mustard.results.find params[:id]

    render json: @result
  end


  def create

    result = @mustard.results.add({result_type: result_params[:result_type],
                          environment_id: result_params[:environment_id],
                          testcase_id: result_params[:testcase_id],
                          execution_id: result_params[:execution_id],
                          status: result_params[:status],
                          comment: result_params[:comment]
                         })


    if result['error']
      render json: {error: "Result Error [#{result['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success: "Manual Result Created"}
    end

  end

  def runner_result
    result = @mustard.results.add({result_type: result_params[:result_type],
                                   environment_id: result_params[:environment_id],
                                   testcase_id: result_params[:testcase_id],
                                   execution_id: result_params[:execution_id],
                                   status: result_params[:status],
                                   comment: result_params[:comment]
                                  })

    render json: {error: "Result Error [#{result['error']}]"} and return if result['error']



    next_test = @mustard.executions.next_test(params[:id])

    redirect_back fallback_location: root_path, flash: { alert: "Failed to get next test"} and return if next_test['error']

    @execution_id = result_params[:execution_id]

    render partial: 'results/next_runner', locals: {execution_id: result_params[:execution_id], next_test: next_test['testcase']}
  end


  def screenshot

    screenshot = @mustard.results.screenshot(params[:id], params[:screenshot_id])

    if screenshot['error']
      render json: {error: "Screenshot Error [#{screenshot['error']}]"}
    else
      redirect_to screenshot['screenshot']
    end

  end

  def step_log

    @result = @mustard.results.find params[:id]

    redirect_back fallback_location: root_path, flash: { alert: "Failed to find result"} and return if result['error']

  end

  private

  def result_params

      params.require(:result).permit(:result_type, :environment_id, :testcase_id, :execution_id, :status, :comment)

  end
end
