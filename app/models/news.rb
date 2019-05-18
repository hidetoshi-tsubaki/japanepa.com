class News < ApplicationRecord
  validates :eyecatch,:title,:contents ,presence: true
  # enum tag: { stuby_in_japan: 1, lifestyle: 2, news: 3, work_in_japan: 4}
end
