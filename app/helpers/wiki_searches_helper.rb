module WikiSearchesHelper
  require 'net/http'

  def search_params
    params.require(:wiki_search).permit(:start_title, :goal_title)
  end

  # "CKGL", "Kitchener,_Ontario", "Germans", "Adolf_Hitler", 531 seconds
  # CKLG ??
  # 314 for JAVA!
  def get_steps(start_title, goal_title)
    return "PAGE !EXISTS" unless page_exists(start_title.gsub(' ', '_')) && page_exists(goal_title.gsub(' ', '_'))
    return "SEARCH EXISTS" unless !search_exists(start_title.gsub('_', ' '), goal_title.gsub('_', ' '))
    a = Time.now
    visited_links = [start_title]
    root = TreeNode.new(nil, start_title.gsub(' ', '_'))
    queue = [root]
    current = root
    i = 0
    parameterized_goal_title = goal_title.gsub(' ', '_')
    until current.content.casecmp(parameterized_goal_title) == 0
      puts i
      puts current.content
      i+=1
      current = queue.shift
      current_page_links = get_internal_links(current.content)
      if current_page_links.any? {|l| l.casecmp(parameterized_goal_title) == 0}
        current = current.add_child(parameterized_goal_title)
        break
      end
      current_page_links.each do |l|
        unless visited_links.any? {|v| v.casecmp(l) == 0}
          queue << current.add_child(l)
          visited_links << l
        end
      end
    end
    steps = []
    current.parentage.each {|s| steps << s.content.gsub('_', ' ')}
    puts "TIME FOR COMPLETION: #{1000*(Time.now - a)}"
    steps
  end

  def get_internal_links(page)
    source = Net::HTTP.get("en.wikipedia.org", "/wiki/" << page)
    links = source.scan(/href="\/wiki\/([^"]+)"/).flatten
    links = remove_non_wiki_pages(links)
    links = links.uniq
  end

  def remove_non_wiki_pages(l)
    new_links = []
    l.each do |link|
      if link !~ /\AMain_Page|\A((File)|(Template)|(Template_talk)|(Portal)|(Category)|(Help)|(Wikipedia)|(Talk)|(Special)|(Book)):.+/i
        new_links << link
      end
    end
    new_links
  end

  def page_exists(page)
    s = Net::HTTP.get("en.wikipedia.org", "/wiki/" << page)
    !s.empty? && !s.include?("Wikipedia does not have an article with this exact name")
  end

  def search_exists(start, goal)
    !WikiSearch.find_by("lower(start_title) = ? AND lower(goal_title) = ?", start.downcase, goal.downcase).nil?
  end


  class TreeNode

    attr_accessor :content
    attr_accessor :parent
    attr_accessor :children

    def initialize(parent, content)
      @parent = parent
      @content = content
      @children = []
    end

    def add_child(content)
      @children << TreeNode.new(self, content)
      @children.last
    end

    def is_root?
      @parent == nil
    end

    # Nodes from self to root
    def parentage
      parentage_array = [self]
      prev_parent = self.parent
      while prev_parent
        parentage_array << prev_parent
        prev_parent = prev_parent.parent
      end
      parentage_array.reverse!
    end

    def to_s
      "Node"
    end

  end





end
