class StaticPagesController < ApplicationController
  def home
  end

  def question
  end

  def score
    gon.number = params[:id]
  end
end
