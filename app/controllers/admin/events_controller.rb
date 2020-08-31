class Admin::EventsController < ApplicationController
  before_action :authenticate_admin!
  before_action :from_calendar?, except: [:index, :calendar, :search]

  def index
    @q = Event.ransack(params[:q])
    @events = @q.result(distinct: true).paginate(params[:page], 15)
  end

  def calendar
    @events = Event.all
  end

  def new
    @event = Event.new(start_time: params[:date])
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to_event_page
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
      redirect_to_event_page
    else
      render 'edit'
    end
  end

  def destroy
    @event = Event.find(params[:id])
    @event.destroy
    respond_to do |format|
      format.html { redirect_to_event_page }
      format.js { render :action => "destroy" }
    end
  end

  def search
    is_pagination?(params)
    if !params[:q]['name_or_detail_cont_any'].nil?
      params[:q]['name_or_detail_cont_any'] = params[:q]['name_or_detail_cont_any'].split(/[ ]/)
      @keywords = Event.ransack(params[:q])
      @events = @keywords.result.paginate(params[:page], 15)
      @q = Event.ransack(params[:q])
    else
      @q = Event.ransack(params[:q])
      @events = @q.result(distinct: true).paginate(params[:page], 15)
    end
    render template: 'admin/events/index'
  end

  private

  def event_params
    params.require(:event).permit(:name, :detail, :start_time, :end_time, :status)
  end

  def is_pagination?(params)
    if params[:q]['name_or_detail_cont_any'].is_a?(Array)
      params[:q]['name_or_detail_cont_any'] = params[:q]['name_or_detail_cont_any'].join(" ")
    end
  end

  def from_calendar?
    @from_calendar = params[:from_calendar]
  end

  def redirect_to_event_page
    if params[:from_calendar].present?
      redirect_to admin_events_path
    else
      redirect_to calendar_admin_events_path(start_date: @event.start_time)
    end
  end
end
