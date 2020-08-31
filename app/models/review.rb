class Review < ApplicationRecord
  belongs_to :user
  belongs_to :category, foreign_key: 'title_id', class_name: 'QuizCategory'
  validates :user_id, :title_id, :count, :next_time, presence: :ture
  validates :user_id, :uniqueness => { :scope => :title_id }

  def overdue?
    next_time < Date.today.prev_day(2)
  end

  def save_as_new_record
    self.next_time = Date.tomorrow.end_of_day
    save
  end

  def update_next_time_and_count
    if next_time > Date.today.end_of_day
      update(next_time: Date.today.next_day(1), count: 1)
    else
      case count
      when 0
        update_info(1)
      when 1
        update_info(2)
      when 2
        update_info(5)
      when 3
        update_info(7)
      when 4
        update_info(14)
      end
    end
  end

  def update_info(number)
    update(next_time: Date.today.next_day(number), count: count + 1)
  end

  def reset_count
    update(count: 0, next_time: nil)
  end
end
