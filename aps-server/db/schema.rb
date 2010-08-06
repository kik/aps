# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20100730220250) do

  create_table "answers", :force => true do |t|
    t.integer  "problem_id"
    t.integer  "language_id"
    t.text     "user"
    t.text     "file"
    t.integer  "size"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "languages", :force => true do |t|
    t.text     "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "problems", :force => true do |t|
    t.text     "title"
    t.text     "options"
    t.text     "description"
    t.text     "theorem"
    t.text     "verifier"
    t.text     "assumption"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
