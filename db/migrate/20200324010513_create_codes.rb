class CreateCodes < ActiveRecord::Migration[6.0]
  def change
    create_table :codes do |t|
      t.string :color0
      t.string :color1
      t.string :color2
      t.string :color3
      t.string :color4
      t.string :color5
    end
  end
end
