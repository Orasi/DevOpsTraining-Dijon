class ResultsController < ApplicationController

  def show
    puts "BEFORE RESULTS FIND"
    @result = @mustard.results.find params[:id]

    render json: @result
  end

end
