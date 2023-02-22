ActiveRecord::Schema.define(version: 2023_02_21_021742) do

  enable_extension "plpgsql"

  create_table "tasks", force: :cascade do |t|
    t.string "title", limit: 80, null: false
    t.text "content", null: false
    # limit: stringフィールドについては最大文字数を、
    # text/binary/integerについては最大バイト数を設定可能。
    # 今回のマイグレーションでcontentにlimitが入らなかったのは最大文字数で制限をかけたから。
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end
end
