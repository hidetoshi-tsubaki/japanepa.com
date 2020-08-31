module EventsHelper
  def event_color(event_id)
    if event_id % 5 == 0
      "event_brown"
    elsif event_id % 4 == 0
      "event_green"
    elsif event_id % 3 == 0
      "event_yellow"
    elsif event_id % 2 == 0
      "event_blue"
    else
      "event_red"
    end
  end

  def continues_few_days?(event)
    return unless event.end_time
    event.start_time != event.end_time
  end

  def show_event_date(event)
    if continues_few_days?(event)
      "〜 " + event.end_time.strftime('%Y/%m/%d')
    end
  end
end
