class CreateWikiSearches < ActiveRecord::Migration
  def change
    create_table :wiki_searches do |t|
      t.string :start_title
      t.string :goal_title

      t.timestamps
    end
  end
end
