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

    @execution = @mustard.executions.find(params[:id])

    if params[:keyword] && params[:keyword] != 'All'
      if @execution['execution']['fast']
        next_test = @mustard.executions.next_test(params[:id], keywords: params[:keyword])
      else
        next_test = @mustard.executions.next_test(params[:id], keywords: params[:keyword], environment: result_params[:environment_id])
      end
    else
      if @execution['execution']['fast']
        next_test = @mustard.executions.next_test(params[:id])
      else
        next_test = @mustard.executions.next_test(params[:id], environment: result_params[:environment_id])
      end

    end

    render partial: 'results/next_runner_no_remaining', locals: {text: "Failed to get next test. #{next_test['error']}", execution_id: params[:id]}  and return if next_test['error']


    @keywords = @execution['execution']

    render partial: 'results/next_runner_no_remaining', locals: {text: 'No Remaining Test', keyword: params[:keyword], execution_id: params[:id] } and return  unless next_test['testcase']['id']

    @environments = @execution['execution']

    @selected = @environments['environments'].dup.detect{|e| e['uuid'] == result_params[:environment_id]}['uuid']

    cookies[:last_environment] = YAML::dump @selected['uuid']

    @execution_id = result_params[:execution_id].dup

    render partial: 'results/next_runner', locals: {execution_id: result_params[:execution_id], next_test: next_test['testcase'], keyword: params[:keyword]}
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

    result = @mustard.results.find params[:id]

    redirect_back fallback_location: root_path, flash: { alert: "Failed to find result"} and return if result['error']

    @step_log = result['result']['results'][0]['step_log']

    render layout: false

  end

  private

  def result_params

      params.require(:result).permit(:result_type, :environment_id, :testcase_id, :execution_id, :status, :comment)

  end
end
