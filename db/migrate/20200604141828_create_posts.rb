class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|

    	t.string :title
    	t.text :body
    	t.float :rate
    	t.string :image_id
    	t.integer :user_id
    	t.integer :genre_id
    	t.integer :favorite_id

      t.timestamps
    end
  end
end
