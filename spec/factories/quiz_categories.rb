FactoryBot.define do
  factory :quiz_category do
    name { "category" }
  end

  factory :category_A, class: QuizCategory do
    name { "category_a" }
  end

  factory :cotegory_B, class: QuizCategory do
    name { "category_b" }
  end

end
# t.string "name"
# t.datetime "created_at", null: false
# t.datetime "updated_at", null: false
# t.integer "parent_id"
# t.integer "lft"
# t.integer "rgt"
# t.integer "depth"
# t.integer "children_count"
# t.integer "position"
# t.index ["depth"], name: "index_quiz_categories_on_depth"
# t.index ["lft"], name: "index_quiz_categories_on_lft"
# t.index ["parent_id"], name: "index_quiz_categories_on_parent_id"
# t.index ["rgt"], name: "index_quiz_categories_on_rgt"
