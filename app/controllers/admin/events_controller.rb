class Admin::EventsController < ApplicationController

  def index
    @q = Event.ransack(params[:q])
    @events = @q.result(distinct: true).page(params[:page])
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to admin_events_path
    else
      render 'new'
    end
  end

  def edit
    @event = Event.find(params[:id])
  end

  def update
    @event = Event.find(params[:id])
    @event.update(event_params)
    if @event.save
      redirect_to admin_events_path
    else
      render 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    respond_to do |format|
      format.html { redirect_to admin_events_path }
      format.js { render :action => "destroy" }
    end
  end

  def search
    is_pagination?(params)
    if params[:q]['name_or_detail_cont_any'] != nil
      params[:q]['name_or_detail_cont_any'] = params[:q]['name_or_detail_cont_any'].split(/[ ]/)
      @keywords = Event.ransack(params[:q])
      @events = @keywords.result.page(params[:page])
      @q = Event.ransack(params[:q])
    else
      @q = Event.ransack(params[:q])
      @events = @q.result(distinct: true).page(params[:page])
    end
    render template: 'admin/events/index'
  end

  private

  def event_params
    params.require(:event).permit(:name, :detail, :start_time, :end_time, :status)
  end

  def is_pagination?(params)
    if params[:q]['name_or_detail_cont_any'].kind_of?(Array)
      params[:q]['name_or_detail_cont_any'] = params[:q]['name_or_detail_cont_any'].join(" ")
    end
  end
end
