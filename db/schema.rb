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

ActiveRecord::Schema.define(version: 20191030083857) do

  create_table "class_sections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "level_id"
    t.integer  "section_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "school_branch_id"
    t.index ["level_id"], name: "index_class_sections_on_level_id", using: :btree
    t.index ["school_branch_id"], name: "index_class_sections_on_school_branch_id", using: :btree
    t.index ["section_id"], name: "index_class_sections_on_section_id", using: :btree
  end

  create_table "expenses", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "expense_type"
    t.integer  "expense"
    t.text     "comment",          limit: 65535
    t.integer  "school_branch_id"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.index ["school_branch_id"], name: "index_expenses_on_school_branch_id", using: :btree
  end

  create_table "levels", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "comment"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "school_id"
    t.integer  "school_branch_id"
    t.index ["school_branch_id"], name: "index_levels_on_school_branch_id", using: :btree
    t.index ["school_id"], name: "index_levels_on_school_id", using: :btree
  end

  create_table "salaries", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer  "paid_salary"
    t.integer  "advance",                           default: 0
    t.integer  "leaves_in_month",                   default: 0
    t.integer  "teacher_id"
    t.integer  "school_branch_id"
    t.datetime "created_at",                                    null: false
    t.datetime "updated_at",                                    null: false
    t.integer  "staff_id"
    t.integer  "paid_to"
    t.integer  "payment_type",                      default: 0
    t.integer  "advance_due_till_this_transaction", default: 0
    t.index ["school_branch_id"], name: "index_salaries_on_school_branch_id", using: :btree
    t.index ["staff_id"], name: "index_salaries_on_staff_id", using: :btree
    t.index ["teacher_id"], name: "index_salaries_on_teacher_id", using: :btree
  end

  create_table "school_branches", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.text     "address",    limit: 65535
    t.string   "code"
    t.integer  "school_id"
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.boolean  "active"
    t.index ["school_id"], name: "index_school_branches_on_school_id", using: :btree
  end

  create_table "schools", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "code"
    t.text     "address",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  create_table "sections", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "school_id"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "school_branch_id"
    t.index ["school_branch_id"], name: "index_sections_on_school_branch_id", using: :btree
    t.index ["school_id"], name: "index_sections_on_school_id", using: :btree
  end

  create_table "staffs", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "father"
    t.string   "education"
    t.string   "phone"
    t.string   "address"
    t.string   "cnic"
    t.date     "date_of_joining"
    t.date     "date_of_leaving"
    t.integer  "yearly_increment"
    t.integer  "monthly_salary"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "school_branch_id"
    t.boolean  "terminated",       default: false
    t.datetime "terminated_at",    default: -> { "CURRENT_TIMESTAMP" }
    t.boolean  "deleted",          default: false
    t.datetime "deleted_at",       default: -> { "CURRENT_TIMESTAMP" }
    t.integer  "advance_amount",   default: 0
    t.integer  "gender"
    t.index ["school_branch_id"], name: "index_staffs_on_school_branch_id", using: :btree
  end

  create_table "student_fees", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.date     "paid_date"
    t.integer  "paid_fee"
    t.string   "fee_type"
    t.integer  "student_id"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "balance",    default: 0
    t.integer  "credit",     default: 0
    t.index ["student_id"], name: "index_student_fees_on_student_id", using: :btree
  end

  create_table "students", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.date     "date_of_birth"
    t.string   "phone_no"
    t.integer  "monthly_fee"
    t.text     "address",            limit: 65535
    t.integer  "class_section_id"
    t.datetime "created_at",                                                            null: false
    t.datetime "updated_at",                                                            null: false
    t.string   "father_name"
    t.integer  "balance",                          default: 0
    t.integer  "school_branch_id"
    t.boolean  "terminated",                       default: false
    t.datetime "terminated_at",                    default: -> { "CURRENT_TIMESTAMP" }
    t.boolean  "deleted",                          default: false
    t.datetime "deleted_at",                       default: -> { "CURRENT_TIMESTAMP" }
    t.integer  "gender"
    t.integer  "admission",                        default: 0
    t.integer  "security",                         default: 0
    t.integer  "paper_fund",                       default: 0
    t.integer  "admission_balance",                default: 0
    t.integer  "security_balance",                 default: 0
    t.integer  "paper_fund_balance",               default: 0
    t.integer  "student_type",                     default: 0
    t.string   "phone_sec"
    t.index ["class_section_id"], name: "index_students_on_class_section_id", using: :btree
    t.index ["school_branch_id"], name: "index_students_on_school_branch_id", using: :btree
  end

  create_table "teachers", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.string   "father"
    t.string   "education"
    t.string   "phone"
    t.string   "address"
    t.string   "cnic"
    t.date     "date_of_joining"
    t.date     "date_of_leaving"
    t.integer  "yearly_increment"
    t.integer  "monthly_salary"
    t.datetime "created_at",                                            null: false
    t.datetime "updated_at",                                            null: false
    t.integer  "school_branch_id"
    t.boolean  "terminated",       default: false
    t.datetime "terminated_at",    default: -> { "CURRENT_TIMESTAMP" }
    t.boolean  "deleted",          default: false
    t.datetime "deleted_at",       default: -> { "CURRENT_TIMESTAMP" }
    t.integer  "advance_amount",   default: 0
    t.integer  "gender"
    t.integer  "level_id"
    t.integer  "section_id"
    t.index ["level_id"], name: "index_teachers_on_level_id", using: :btree
    t.index ["school_branch_id"], name: "index_teachers_on_school_branch_id", using: :btree
    t.index ["section_id"], name: "index_teachers_on_section_id", using: :btree
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.integer  "school_id"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["school_id"], name: "index_users_on_school_id", using: :btree
  end

  create_table "widows", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string   "name"
    t.integer  "monthly_aid"
    t.text     "comment",     limit: 65535
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.boolean  "paid"
  end

  add_foreign_key "class_sections", "levels"
  add_foreign_key "class_sections", "sections"
  add_foreign_key "expenses", "school_branches"
  add_foreign_key "levels", "schools"
  add_foreign_key "salaries", "school_branches"
  add_foreign_key "salaries", "staffs"
  add_foreign_key "salaries", "teachers"
  add_foreign_key "school_branches", "schools"
  add_foreign_key "sections", "schools"
  add_foreign_key "student_fees", "students"
  add_foreign_key "students", "class_sections"
  add_foreign_key "students", "school_branches"
  add_foreign_key "teachers", "levels"
  add_foreign_key "teachers", "sections"
  add_foreign_key "users", "schools"
end
