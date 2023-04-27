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

ActiveRecord::Schema[7.0].define(version: 2023_04_27_142555) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "input_bundles", force: :cascade do |t|
    t.text "name", null: false
    t.text "path", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_input_bundles_on_name"
    t.index ["path"], name: "index_input_bundles_on_path"
  end

  create_table "pipeline_outputs", force: :cascade do |t|
    t.text "run_id", null: false
    t.bigint "project_id", null: false
    t.text "pipeline_name", null: false
    t.text "pipeline_version", null: false
    t.text "platorm", null: false
    t.text "platform_identifier", null: false
    t.datetime "run_completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline_name"], name: "index_pipeline_outputs_on_pipeline_name"
    t.index ["pipeline_version"], name: "index_pipeline_outputs_on_pipeline_version"
    t.index ["platform_identifier"], name: "index_pipeline_outputs_on_platform_identifier"
    t.index ["platorm"], name: "index_pipeline_outputs_on_platorm"
    t.index ["project_id"], name: "index_pipeline_outputs_on_project_id"
    t.index ["run_id"], name: "index_pipeline_outputs_on_run_id"
  end

  create_table "pipeline_outputs_sequencing_products", force: :cascade do |t|
    t.integer "pipeline_output_id", null: false
    t.integer "sequencing_product_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["pipeline_output_id"], name: "idx_pipelineoutput_bridge"
    t.index ["sequencing_product_id"], name: "idx_sequenceproduct_bridge"
  end

  create_table "projects", force: :cascade do |t|
    t.text "name", null: false
    t.text "lab", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lab"], name: "index_projects_on_lab"
    t.index ["name"], name: "index_projects_on_name"
  end

  create_table "samples", force: :cascade do |t|
    t.text "name", null: false
    t.text "species", null: false
    t.text "individual", null: false
    t.text "timepoint"
    t.text "disease_status"
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["disease_status"], name: "index_samples_on_disease_status"
    t.index ["individual"], name: "index_samples_on_individual"
    t.index ["name"], name: "index_samples_on_name"
    t.index ["project_id"], name: "index_samples_on_project_id"
    t.index ["species"], name: "index_samples_on_species"
    t.index ["timepoint"], name: "index_samples_on_timepoint"
  end

  create_table "sequencing_products", force: :cascade do |t|
    t.bigint "sample_id", null: false
    t.text "instrument", null: false
    t.text "timepoint"
    t.text "flow_cell_id"
    t.text "unaligned_data_path", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flow_cell_id"], name: "index_sequencing_products_on_flow_cell_id"
    t.index ["instrument"], name: "index_sequencing_products_on_instrument"
    t.index ["sample_id"], name: "index_sequencing_products_on_sample_id"
    t.index ["timepoint"], name: "index_sequencing_products_on_timepoint"
    t.index ["unaligned_data_path"], name: "index_sequencing_products_on_unaligned_data_path"
  end

  create_table "taggable_tags", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "taggable_type"
    t.bigint "taggable_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id"], name: "index_taggable_tags_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggable_tags_on_taggable"
  end

  create_table "tags", force: :cascade do |t|
    t.text "tag", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag"], name: "index_tags_on_tag"
  end

  create_table "users", force: :cascade do |t|
    t.text "email", null: false
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["name"], name: "index_users_on_name"
  end

  add_foreign_key "pipeline_outputs", "projects"
  add_foreign_key "pipeline_outputs_sequencing_products", "pipeline_outputs", name: "fk_pipelineoutputs_bridge"
  add_foreign_key "pipeline_outputs_sequencing_products", "sequencing_products", name: "fk_sequenceproduct_bridge"
  add_foreign_key "samples", "projects"
  add_foreign_key "sequencing_products", "samples"
end
