# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_08_08_090913) do

  create_table "active_storage_attachments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.bigint "byte_size", null: false
    t.string "checksum", null: false
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "admins", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.index ["email"], name: "index_admins_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true
  end

  create_table "announcement_checks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "announcement_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["announcement_id"], name: "index_announcement_checks_on_announcement_id"
    t.index ["user_id"], name: "index_announcement_checks_on_user_id"
  end

  create_table "announcements", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "contents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "impressions_count", default: 0
    t.boolean "status", default: false
  end

  create_table "articles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "title"
    t.string "contents"
    t.string "img"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "lead"
    t.integer "impressions_count", default: 0
    t.integer "bookmarks_count", default: 0, null: false
    t.integer "likes_count", default: 0, null: false
    t.boolean "status", default: false
    t.boolean "delete_img", default: false
  end

  create_table "bookmarks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_bookmarks_on_article_id"
    t.index ["user_id"], name: "index_bookmarks_on_user_id"
  end

  create_table "comments", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "talk_id"
    t.string "contents"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["talk_id"], name: "index_comments_on_talk_id"
    t.index ["user_id"], name: "index_comments_on_user_id"
  end

  create_table "communities", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.string "img"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "introduction"
    t.integer "founder_id"
    t.integer "member_count", default: 0, null: false
    t.integer "talk_count", default: 0, null: false
  end

  create_table "community_users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "community_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["community_id"], name: "index_community_users_on_community_id"
    t.index ["user_id"], name: "index_community_users_on_user_id"
  end

  create_table "countings", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "users"
    t.integer "quiz_play"
    t.integer "article_views"
    t.integer "communities"
    t.integer "talks"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "events", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.date "start_time"
    t.date "end_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "detail"
    t.integer "impressions_count", default: 0
    t.boolean "status", default: false
  end

  create_table "impressions", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "impressionable_type"
    t.integer "impressionable_id"
    t.integer "user_id"
    t.string "controller_name"
    t.string "action_name"
    t.string "view_name"
    t.string "request_hash"
    t.string "ip_address"
    t.string "session_hash"
    t.text "message"
    t.text "referrer"
    t.text "params"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["controller_name", "action_name", "ip_address"], name: "controlleraction_ip_index"
    t.index ["controller_name", "action_name", "request_hash"], name: "controlleraction_request_index"
    t.index ["controller_name", "action_name", "session_hash"], name: "controlleraction_session_index"
    t.index ["impressionable_type", "impressionable_id", "ip_address"], name: "poly_ip_index"
    t.index ["impressionable_type", "impressionable_id", "params"], name: "poly_params_request_index", length: { params: 255 }
    t.index ["impressionable_type", "impressionable_id", "request_hash"], name: "poly_request_index"
    t.index ["impressionable_type", "impressionable_id", "session_hash"], name: "poly_session_index"
    t.index ["impressionable_type", "message", "impressionable_id"], name: "impressionable_type_message_index", length: { message: 255 }
    t.index ["user_id"], name: "index_impressions_on_user_id"
  end

  create_table "learning_levels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "percentage", default: 0
    t.integer "user_id"
    t.integer "title_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "levels", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "threshold", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "like_articles", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "article_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["article_id"], name: "index_like_articles_on_article_id"
    t.index ["user_id"], name: "index_like_articles_on_user_id"
  end

  create_table "like_talks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "talk_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["talk_id"], name: "index_like_talks_on_talk_id"
    t.index ["user_id"], name: "index_like_talks_on_user_id"
  end

  create_table "masters", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "title_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "mistakes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "count", default: 1
    t.integer "user_id"
    t.integer "quiz_id"
    t.integer "title_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quiz_categories", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "parent_id"
    t.integer "lft"
    t.integer "rgt"
    t.integer "depth"
    t.integer "children_count"
    t.integer "position"
    t.index ["depth"], name: "index_quiz_categories_on_depth"
    t.index ["lft"], name: "index_quiz_categories_on_lft"
    t.index ["parent_id"], name: "index_quiz_categories_on_parent_id"
    t.index ["rgt"], name: "index_quiz_categories_on_rgt"
  end

  create_table "quiz_experiences", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "title_id", null: false
    t.decimal "rate", precision: 10, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quizzes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "question", null: false
    t.string "question_html", null: false
    t.string "choice1", null: false
    t.string "choice2", null: false
    t.string "choice3", null: false
    t.string "choice4", null: false
    t.bigint "category_id"
    t.index ["category_id"], name: "index_quizzes_on_category_id"
  end

  create_table "reviews", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "title_id"
    t.integer "count", default: 1
    t.date "next_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "score_records", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "score", null: false
    t.integer "title_id", null: false
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_score_records_on_user_id"
  end

  create_table "taggings", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "name", collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "talks", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.text "content"
    t.bigint "user_id"
    t.string "img"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "community_id"
    t.integer "likes_count", default: 0
    t.integer "comments_count", default: 0
    t.index ["community_id"], name: "index_talks_on_community_id"
    t.index ["user_id"], name: "index_talks_on_user_id"
  end

  create_table "user_experiences", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.integer "user_id"
    t.integer "total_point", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.string "email", default: ""
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string "current_sign_in_ip"
    t.string "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "uid"
    t.string "provider"
    t.string "name"
    t.string "country"
    t.string "current_address"
    t.string "img", default: "japanepa.png"
    t.integer "community_count", default: 0, null: false
    t.integer "talk_count", default: 0, null: false
    t.integer "play_count", default: 0, null: false
    t.integer "level", default: 1
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "announcement_checks", "announcements"
  add_foreign_key "announcement_checks", "users"
  add_foreign_key "bookmarks", "articles"
  add_foreign_key "bookmarks", "users"
  add_foreign_key "comments", "talks"
  add_foreign_key "comments", "users"
  add_foreign_key "community_users", "communities"
  add_foreign_key "community_users", "users"
  add_foreign_key "like_articles", "articles"
  add_foreign_key "like_articles", "users"
  add_foreign_key "like_talks", "talks"
  add_foreign_key "like_talks", "users"
  add_foreign_key "quizzes", "quiz_categories", column: "category_id"
  add_foreign_key "score_records", "users"
  add_foreign_key "talks", "communities"
  add_foreign_key "talks", "users"
end
