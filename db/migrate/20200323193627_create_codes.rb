class CreateCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :codes do |t|
      t.integer :color1, default: -1
      t.integer :color2, default: -1
      t.integer :color3, default: -1
      t.integer :color4, default: -1
      t.integer :color5, default: -1
      t.integer :color6, default: -1
    end
  end
end
