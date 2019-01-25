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

ActiveRecord::Schema.define(version: 2019_01_23_035939) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "fuzzystrmatch"
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "authorization_sessions", force: :cascade do |t|
    t.bigint "authorization_id"
    t.string "session_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "activated"
    t.datetime "expires_at"
    t.index ["authorization_id"], name: "index_authorization_sessions_on_authorization_id"
    t.index ["session_id"], name: "index_authorization_sessions_on_session_id"
  end

  create_table "authorizations", force: :cascade do |t|
    t.bigint "group_id"
    t.string "email", default: "", null: false
    t.text "avatar"
    t.bigint "person_id", null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "uid"
    t.string "provider"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email", "provider"], name: "index_authorizations_on_email_and_provider", unique: true
    t.index ["group_id"], name: "index_authorizations_on_group_id"
    t.index ["person_id"], name: "index_authorizations_on_person_id"
  end

  create_table "authors", force: :cascade do |t|
    t.bigint "post_id"
    t.bigint "person_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["person_id"], name: "index_authors_on_person_id"
    t.index ["post_id"], name: "index_authors_on_post_id"
  end

  create_table "builds", force: :cascade do |t|
    t.text "notes"
    t.text "git_url"
    t.string "git_sha"
    t.text "signature"
    t.bigint "public_key_id"
    t.bigint "group_id"
    t.boolean "live"
    t.datetime "live_at"
    t.text "html"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_builds_on_group_id"
    t.index ["live"], name: "index_builds_on_live"
    t.index ["live_at"], name: "index_builds_on_live_at"
    t.index ["public_key_id"], name: "index_builds_on_public_key_id"
  end

  create_table "channels", force: :cascade do |t|
    t.bigint "group_id"
    t.string "locale"
    t.string "name"
    t.string "slug"
    t.boolean "published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_channels_on_group_id"
    t.index ["locale", "slug"], name: "index_channels_on_locale_and_slug", unique: true
    t.index ["published"], name: "index_channels_on_published"
  end

  create_table "events", force: :cascade do |t|
    t.bigint "group_id"
    t.text "title"
    t.text "description"
    t.string "level"
    t.datetime "starts_at"
    t.datetime "ends_at"
    t.bigint "venue_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_events_on_group_id"
    t.index ["title"], name: "index_events_on_title"
    t.index ["venue_id"], name: "index_events_on_venue_id"
  end

  create_table "groups", force: :cascade do |t|
    t.text "name", null: false
    t.string "email"
    t.string "hostname"
    t.string "api_key"
    t.string "timezone"
    t.string "locale"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "current_build_id"
    t.text "encrypted_stripe_publishable_key"
    t.text "encrypted_stripe_secret_key"
    t.text "apple_developer_merchantid_domain_association"
    t.integer "current_website_id"
    t.string "glitch_url"
  end

  create_table "guests", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "person_id"
    t.text "role"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_guests_on_event_id"
    t.index ["person_id"], name: "index_guests_on_person_id"
  end

  create_table "locations", force: :cascade do |t|
    t.bigint "group_id"
    t.text "name", null: false
    t.text "website"
    t.text "address_line"
    t.text "extended_address"
    t.text "city"
    t.string "region_code"
    t.string "postal_code"
    t.bigint "photo_id"
    t.string "latitude"
    t.string "longitude"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_locations_on_group_id"
    t.index ["photo_id"], name: "index_locations_on_photo_id"
  end

  create_table "people", force: :cascade do |t|
    t.bigint "group_id"
    t.text "name", null: false
    t.string "email"
    t.text "biography"
    t.text "website"
    t.string "role"
    t.datetime "published_at"
    t.boolean "published", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "stripe_customer_id"
    t.index ["email"], name: "index_people_on_email"
    t.index ["group_id"], name: "index_people_on_group_id"
    t.index ["name"], name: "index_people_on_name"
    t.index ["published"], name: "index_people_on_published"
    t.index ["published_at"], name: "index_people_on_published_at"
  end

  create_table "photos", force: :cascade do |t|
    t.bigint "group_id"
    t.text "url"
    t.string "filename"
    t.integer "filesize"
    t.integer "width"
    t.integer "height"
    t.text "title"
    t.text "caption"
    t.text "tags", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_photos_on_group_id"
  end

  create_table "portraits", force: :cascade do |t|
    t.bigint "person_id"
    t.bigint "photo_id"
    t.index ["person_id"], name: "index_portraits_on_person_id"
    t.index ["photo_id"], name: "index_portraits_on_photo_id"
  end

  create_table "posts", force: :cascade do |t|
    t.bigint "group_id"
    t.text "title"
    t.text "body"
    t.string "slug"
    t.datetime "published_at"
    t.boolean "published", default: false
    t.boolean "pinned", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "channel_id"
    t.index ["group_id"], name: "index_posts_on_group_id"
    t.index ["pinned"], name: "index_posts_on_pinned"
    t.index ["published"], name: "index_posts_on_published"
    t.index ["published_at"], name: "index_posts_on_published_at"
    t.index ["slug"], name: "index_posts_on_slug"
    t.index ["title"], name: "index_posts_on_title"
  end

  create_table "public_keys", force: :cascade do |t|
    t.string "name", limit: 191, null: false
    t.text "key", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "person_id"
    t.bigint "group_id"
    t.index ["group_id"], name: "index_public_keys_on_group_id"
    t.index ["person_id"], name: "index_public_keys_on_person_id"
  end

  create_table "published_channels", force: :cascade do |t|
    t.bigint "published_post_id"
    t.bigint "channel_id"
    t.index ["channel_id"], name: "index_published_channels_on_channel_id"
    t.index ["published_post_id", "channel_id"], name: "index_published_channels"
    t.index ["published_post_id"], name: "index_published_channels_on_published_post_id"
  end

  create_table "published_events", id: false, force: :cascade do |t|
    t.bigint "published_post_id"
    t.bigint "event_id"
    t.index ["event_id"], name: "index_published_events_on_event_id"
    t.index ["published_post_id", "event_id"], name: "index_published_events"
    t.index ["published_post_id"], name: "index_published_events_on_published_post_id"
  end

  create_table "published_locations", id: false, force: :cascade do |t|
    t.bigint "published_post_id"
    t.bigint "location_id"
    t.index ["location_id"], name: "index_published_locations_on_location_id"
    t.index ["published_post_id", "location_id"], name: "index_published_locations"
    t.index ["published_post_id"], name: "index_published_locations_on_published_post_id"
  end

  create_table "published_people", force: :cascade do |t|
    t.bigint "published_post_id"
    t.bigint "person_id"
    t.index ["person_id"], name: "index_published_people_on_person_id"
    t.index ["published_post_id", "person_id"], name: "index_published_people"
    t.index ["published_post_id"], name: "index_published_people_on_published_post_id"
  end

  create_table "published_photos", force: :cascade do |t|
    t.bigint "published_post_id"
    t.bigint "photo_id"
    t.index ["photo_id"], name: "index_published_photos_on_photo_id"
    t.index ["published_post_id", "photo_id"], name: "index_published_photos"
    t.index ["published_post_id"], name: "index_published_photos_on_published_post_id"
  end

  create_table "published_posts", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "channel_id"
    t.bigint "post_id"
    t.bigint "published_by_id"
    t.text "title"
    t.text "body"
    t.string "slug"
    t.boolean "featured", default: false
    t.boolean "live", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["channel_id"], name: "index_published_posts_on_channel_id"
    t.index ["featured"], name: "index_published_posts_on_featured"
    t.index ["group_id"], name: "index_published_posts_on_group_id"
    t.index ["live"], name: "index_published_posts_on_live"
    t.index ["post_id"], name: "index_published_posts_on_post_id"
    t.index ["published_by_id"], name: "index_published_posts_on_published_by_id"
    t.index ["slug"], name: "index_published_posts_on_slug"
  end

  create_table "published_tickets", force: :cascade do |t|
    t.bigint "published_post_id"
    t.bigint "ticket_id"
    t.index ["published_post_id", "ticket_id"], name: "index_published_tickets"
    t.index ["published_post_id"], name: "index_published_tickets_on_published_post_id"
    t.index ["ticket_id"], name: "index_published_tickets_on_ticket_id"
  end

  create_table "redirects", force: :cascade do |t|
    t.bigint "group_id"
    t.string "from"
    t.string "to"
    t.index ["from", "to"], name: "index_redirects_on_from_and_to", unique: true
    t.index ["from"], name: "index_redirects_on_from"
    t.index ["group_id"], name: "index_redirects_on_group_id"
    t.index ["to", "from"], name: "index_redirects_on_to_and_from", unique: true
    t.index ["to"], name: "index_redirects_on_to"
  end

  create_table "ticket_stubs", force: :cascade do |t|
    t.bigint "group_id"
    t.bigint "person_id"
    t.bigint "event_id"
    t.bigint "purchase_id"
    t.bigint "ticket_id"
    t.boolean "attended"
    t.string "role"
    t.string "level"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_ticket_stubs_on_event_id"
    t.index ["group_id"], name: "index_ticket_stubs_on_group_id"
    t.index ["person_id"], name: "index_ticket_stubs_on_person_id"
    t.index ["purchase_id"], name: "index_ticket_stubs_on_purchase_id"
    t.index ["ticket_id"], name: "index_ticket_stubs_on_ticket_id"
  end

  create_table "ticketed_events", force: :cascade do |t|
    t.bigint "ticket_id"
    t.bigint "event_id"
    t.index ["event_id"], name: "index_ticketed_events_on_event_id"
    t.index ["ticket_id"], name: "index_ticketed_events_on_ticket_id"
  end

  create_table "tickets", force: :cascade do |t|
    t.bigint "group_id"
    t.text "description"
    t.string "sku"
    t.integer "cost"
    t.integer "quantity"
    t.string "currency"
    t.datetime "valid_from"
    t.datetime "valid_to"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_tickets_on_group_id"
  end

  create_table "transactions", force: :cascade do |t|
    t.bigint "group_id"
    t.text "description"
    t.datetime "paid_at"
    t.bigint "paid_by_id"
    t.bigint "receipt_id"
    t.integer "amount_paid"
    t.integer "amount_owed"
    t.string "currency"
    t.string "payment_method"
    t.text "payment_processor_url"
    t.text "notes"
    t.bigint "ticket_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["description"], name: "index_transactions_on_description"
    t.index ["group_id"], name: "index_transactions_on_group_id"
    t.index ["paid_at"], name: "index_transactions_on_paid_at"
    t.index ["paid_by_id"], name: "index_transactions_on_paid_by_id"
    t.index ["receipt_id"], name: "index_transactions_on_receipt_id"
    t.index ["ticket_id"], name: "index_transactions_on_ticket_id"
  end

  create_table "venues", force: :cascade do |t|
    t.bigint "location_id"
    t.bigint "event_id"
    t.text "extended_address"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_venues_on_event_id"
    t.index ["location_id"], name: "index_venues_on_location_id"
  end

  create_table "websites", force: :cascade do |t|
    t.bigint "group_id"
    t.string "sha"
    t.json "assets"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_websites_on_group_id"
    t.index ["sha"], name: "index_websites_on_sha"
  end

  add_foreign_key "public_keys", "groups"
  add_foreign_key "public_keys", "people"
end
