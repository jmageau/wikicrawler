class CreateWikiPages < ActiveRecord::Migration
  def change
    create_table :wiki_pages do |t|
      t.string :title
      t.text :links

      t.timestamps
    end
  end
end
