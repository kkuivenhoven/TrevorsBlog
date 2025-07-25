# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_26_151531) do
  create_table "blog_post_images", force: :cascade do |t|
    t.integer "blog_post_id", null: false
    t.string "image_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_post_id"], name: "index_blog_post_images_on_blog_post_id"
  end

  create_table "blog_post_sources", force: :cascade do |t|
    t.integer "blog_post_id", null: false
    t.string "source_url"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_post_id"], name: "index_blog_post_sources_on_blog_post_id"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.boolean "is_visible"
    t.datetime "date_published"
    t.string "title"
    t.text "excerpt"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "file_name"
  end

  create_table "fraud_prompts", force: :cascade do |t|
    t.integer "user_id", null: false
    t.string "category"
    t.text "user_input"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "result"
    t.index ["user_id"], name: "index_fraud_prompts_on_user_id"
  end

  create_table "fraud_simulators", force: :cascade do |t|
    t.json "data"
    t.boolean "is_visible"
    t.text "excerpt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "title"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "query_count"
    t.datetime "last_query_at"
    t.boolean "admin", default: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.boolean "notify_fraud_simulators"
    t.boolean "notify_blog_posts"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "blog_post_images", "blog_posts"
  add_foreign_key "blog_post_sources", "blog_posts"
  add_foreign_key "fraud_prompts", "users"
end
