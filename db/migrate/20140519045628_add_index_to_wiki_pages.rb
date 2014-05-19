class AddIndexToWikiPages < ActiveRecord::Migration
  def change
    add_index :wiki_pages, :title
  end
end
