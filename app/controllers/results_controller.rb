class ResultsController < ApplicationController

  def show
    puts "BEFORE RESULTS FIND"
    @result = @mustard.results.find params[:id]

    render json: @result
  end

  def screenshot

    screenshot = @mustard.results.screenshot(params[:id], params[:screenshot_id])

    if screenshot['error']
      render json: {error: "Screenshot Error [#{screenshot['error']}]"}
    else
      redirect_to screenshot['screenshot']
    end

  end
end
