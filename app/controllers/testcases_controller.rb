class TestcasesController < ApplicationController

  def show
    @testcase = @mustard.testcases.find params[:id]
  end
end
