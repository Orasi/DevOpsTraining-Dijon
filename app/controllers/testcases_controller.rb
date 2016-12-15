class TestcasesController < ApplicationController


  def show
    @testcase = @mustard.testcases.find params[:id]
  end


  def edit
    testcase = @mustard.testcases.find(params[:id])

    if testcase['error']
      render json: {error: "User failed to create. Error[#{testcase['error']}]"}, status: :not_found and return
    else
      render partial: 'testcases/testcase_form', locals: {testcase: TestcasePresenter.new(testcase), project_id: testcase['project_id']}
    end
  end


  def create

    reproduction_steps = []

    if params[:reproduction_steps]
      params[:reproduction_steps].keys.each do |k|
        reproduction_steps.append({step_number: k, action: params[:reproduction_steps][k][:action], result: params[:reproduction_steps][k][:result]})
      end
    end

    testcase = @mustard.testcases.add({name: testcase_params[:name],
                                       project_id: testcase_params[:project_id],
                                       validation_id: testcase_params[:validation_id],
                                       reproduction_steps: reproduction_steps
                                      })

    if testcase['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to create testcase. Error[#{testcase['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Testcase #{testcase['uuid']} created"}
    end
  end


  def update
    reproduction_steps = []

    if params[:reproduction_steps]
      params[:reproduction_steps].keys.each do |k|
        reproduction_steps.append({step_number: k, action: params[:reproduction_steps][k][:action], result: params[:reproduction_steps][k][:result]})
      end
    end


    testcase = @mustard.testcases.update(params[:id], {name: testcase_params[:name],
                                                       project_id: testcase_params[:project_id],
                                                       validation_id: testcase_params[:validation_id],
                                                       reproduction_steps: reproduction_steps
    })

    if testcase['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to update team. Error[#{testcase['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Testcase #{testcase['uuid']} updated"}
    end
  end


  def destroy

    testcase = @mustard.testcases.delete(params[:id])

    if testcase['error']
      redirect_back fallback_location: root_path, flash: { alert: "Failed to delete testcase. Error[#{testcase['error']}]"}
    else
      redirect_back fallback_location: root_path, flash: { success:  "Testcase deleted"}
    end

  end


  def import_form

    @project = @mustard.projects.find(params[:id])

    redirect_back fallback_location: root_path, flash: { alert: @project['error']} if @project['error']

  end


  def import

    @project = @mustard.projects.find(params[:id])

    redirect_back fallback_location: root_path, flash: { alert: @project['error']} if @project['error']

    if params[:preview] == 'preview' || params[:preview] == 'true'
      @csv = params[:csv]
      @testcases = @mustard.testcases.import(params[:id], params[:csv], preview: true, update: params[:update])
    else
      @testcases = @mustard.testcases.import(params[:id], params[:csv], update: params[:update])

      redirect_back fallback_location: root_path, flash: { alert: @testcases['error']} and return if @testcases['error']
      redirect_to project_path(params[:id]), flash: { success: 'Testcases imported'} and return unless @testcases['error']
    end

    @update = params[:update]
    redirect_back fallback_location: root_path, flash: { alert: @testcases['error']} if @testcases['error']

  end

  def export
    @project = @mustard.projects.find(params[:id])

    redirect_back fallback_location: root_path, flash: { alert: @project['error']} and return if @project['error']

    @result = @mustard.testcases.export params[:id]

    redirect_back fallback_location: root_path, flash: { alert: @result['error']} and return if @result['error']

    redirect_to @result['report']
  end


  private

  def testcase_params
    params.require(:testcase).permit(:name, :validation_id, :project_id, :reproduction_steps)
  end

end
