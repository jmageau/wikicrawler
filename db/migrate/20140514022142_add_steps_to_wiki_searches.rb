class AddStepsToWikiSearches < ActiveRecord::Migration
  def change
    add_column :wiki_searches, :steps, :text
  end
end
