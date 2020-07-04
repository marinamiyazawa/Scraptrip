class CreateTags < ActiveRecord::Migration[5.2]
  def change
    create_table :tags do |t|
    	t.string :name
    	t.decimal :score
    	t.integer :vision_image_id

      t.timestamps
    end
  end
end
