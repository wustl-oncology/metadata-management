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

ActiveRecord::Schema[7.1].define(version: 2024_02_08_154239) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_trgm"
  enable_extension "plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.string "name", null: false
    t.string "record_type", null: false
    t.bigint "record_id", null: false
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.string "key", null: false
    t.string "filename", null: false
    t.string "content_type"
    t.text "metadata"
    t.string "service_name", null: false
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.datetime "created_at", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "input_bundles", force: :cascade do |t|
    t.text "name", null: false
    t.text "path", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_input_bundles_on_name"
    t.index ["path"], name: "index_input_bundles_on_path"
  end

  create_table "lab_memberships", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "lab_id", null: false
    t.integer "permissions", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["lab_id"], name: "index_lab_memberships_on_lab_id"
    t.index ["user_id"], name: "index_lab_memberships_on_user_id"
  end

  create_table "labs", force: :cascade do |t|
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "pipeline_outputs", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.text "pipeline_name", null: false
    t.text "pipeline_version", null: false
    t.text "platform", null: false
    t.text "platform_identifier", null: false
    t.datetime "run_completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id", null: false
    t.text "data_location", null: false
    t.text "notes"
    t.index "to_tsvector('english'::regconfig, data_location)", name: "index_pipeline_outputs_on_to_tsvector_english_data_location", using: :gin
    t.index ["data_location"], name: "idx_po_location_tri", opclass: :gist_trgm_ops, using: :gist
    t.index ["pipeline_name"], name: "index_pipeline_outputs_on_pipeline_name"
    t.index ["pipeline_version"], name: "index_pipeline_outputs_on_pipeline_version"
    t.index ["platform"], name: "index_pipeline_outputs_on_platform"
    t.index ["platform_identifier"], name: "index_pipeline_outputs_on_platform_identifier"
    t.index ["project_id"], name: "index_pipeline_outputs_on_project_id"
    t.index ["user_id"], name: "index_pipeline_outputs_on_user_id"
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
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.integer "lab_id"
    t.index "to_tsvector('english'::regconfig, name)", name: "index_projects_on_to_tsvector_english_name", using: :gin
    t.index ["name"], name: "idx_project_name_tri", opclass: :gist_trgm_ops, using: :gist
    t.index ["name"], name: "index_projects_on_name"
    t.index ["user_id"], name: "index_projects_on_user_id"
  end

  create_table "projects_samples", id: false, force: :cascade do |t|
    t.bigint "sample_id", null: false
    t.bigint "project_id", null: false
  end

  create_table "samples", force: :cascade do |t|
    t.text "name", null: false
    t.text "species", null: false
    t.text "individual", null: false
    t.text "timepoint"
    t.text "disease_status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index "to_tsvector('english'::regconfig, name)", name: "index_samples_on_to_tsvector_english_name", using: :gin
    t.index ["disease_status"], name: "index_samples_on_disease_status"
    t.index ["individual"], name: "index_samples_on_individual"
    t.index ["name"], name: "idx_sample_name_tri", opclass: :gist_trgm_ops, using: :gist
    t.index ["name"], name: "index_samples_on_name"
    t.index ["species"], name: "index_samples_on_species"
    t.index ["timepoint"], name: "index_samples_on_timepoint"
  end

  create_table "sequencing_products", force: :cascade do |t|
    t.bigint "sample_id", null: false
    t.text "instrument", null: false
    t.text "flow_cell_id"
    t.text "unaligned_data_path", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "library_prep"
    t.text "strand"
    t.text "kit"
    t.text "targeted_capture"
    t.text "paired_end"
    t.text "batch"
    t.index "to_tsvector('english'::regconfig, unaligned_data_path)", name: "idx_on_to_tsvector_english_unaligned_data_path_16c108c372", using: :gin
    t.index ["flow_cell_id"], name: "index_sequencing_products_on_flow_cell_id"
    t.index ["instrument"], name: "index_sequencing_products_on_instrument"
    t.index ["sample_id"], name: "index_sequencing_products_on_sample_id"
    t.index ["unaligned_data_path"], name: "idx_sp_data_path_tri", opclass: :gist_trgm_ops, using: :gist
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

  create_table "uploads", force: :cascade do |t|
    t.bigint "project_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_uploads_on_project_id"
  end

  create_table "users", force: :cascade do |t|
    t.text "email", null: false
    t.text "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "github_uid", null: false
    t.text "api_key", null: false
    t.boolean "admin", default: false, null: false
    t.index ["email"], name: "index_users_on_email"
    t.index ["name"], name: "index_users_on_name"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "lab_memberships", "labs"
  add_foreign_key "lab_memberships", "users"
  add_foreign_key "pipeline_outputs", "projects"
  add_foreign_key "pipeline_outputs_sequencing_products", "pipeline_outputs", name: "fk_pipelineoutputs_bridge"
  add_foreign_key "pipeline_outputs_sequencing_products", "sequencing_products", name: "fk_sequenceproduct_bridge"
  add_foreign_key "projects", "labs"
  add_foreign_key "sequencing_products", "samples"
end
