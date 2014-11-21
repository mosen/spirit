# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 3) do

  create_table "host_statuses", force: true do |t|
    t.string   "IPv4",                limit: 16
    t.string   "MACAddress",          limit: 17
    t.boolean  "diskImageConversion"
    t.string   "hostname"
    t.string   "identifier"
    t.boolean  "multicastStream"
    t.boolean  "online"
    t.string   "dialogDescription"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
  end

  create_table "workflow_status_steps", force: true do |t|
    t.integer  "workflow_status_id"
    t.string   "Comments"
    t.integer  "CompletedStatus"
    t.string   "Name"
    t.integer  "RunningStatus"
    t.datetime "StartedDate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "workflow_statuses", force: true do |t|
    t.integer  "CompletedStatus", default: 0
    t.string   "Name"
    t.integer  "RunningStatus"
    t.datetime "StartedDate"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
