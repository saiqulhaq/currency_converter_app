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

ActiveRecord::Schema.define(version: 2019_02_08_153110) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "quotes", force: :cascade do |t|
    t.bigint "rate_id"
    t.integer "price_cents", default: 0, null: false
    t.string "price_currency", default: "USD", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["rate_id"], name: "index_quotes_on_rate_id"
  end

  create_table "rates", force: :cascade do |t|
    t.date "date"
    t.integer "hour"
    t.boolean "historical", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["date", "hour"], name: "index_rates_on_date_and_hour", unique: true
    t.index ["historical"], name: "index_rates_on_historical"
  end

  add_foreign_key "quotes", "rates"
end
