class WikiPage < ActiveRecord::Base
  serialize :links
end
