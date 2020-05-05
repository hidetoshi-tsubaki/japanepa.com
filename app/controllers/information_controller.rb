class InformationController < ApplicationController
  impressionist :actions => [:show]
  def index
    @information = Information.sorted.limit(15)
  end

  def show
    redirect_to root_path unless @info = Information.find_by_id(params[:id])
  end
end