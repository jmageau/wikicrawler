module WikiSearchesHelper
  require 'net/http'

  def search_params
    params.require(:wiki_search).permit(:start_title, :goal_title)
  end

  # "CKGL", "Kitchener,_Ontario", "Germans", "Adolf_Hitler", 531 seconds
  # 314 for JAVA!
  def get_steps(start_title, goal_title)
    a = Time.now
    visited_links = [start_title]
    root = TreeNode.new(nil, start_title.gsub(' ', '_'))
    queue = [root]
    current = root
    i = 0
    parameterized_goal_title = goal_title.gsub(' ', '_')
    until current.content == parameterized_goal_title
      puts i
      puts current.content
      i+=1
      current = queue.shift
      current_page_links = get_internal_links(current.content)
      current_page_links.each do |l|
        if l == parameterized_goal_title
          current = current.add_child(l)
          break
        end
        unless visited_links.include?(l)
          queue << current.add_child(l)
          visited_links << l
        end
      end
    end
    steps = []
    current.parentage.each {|s| steps << s.content.humanize}
    puts "TIME FOR COMPLETION: #{1000*(Time.now - a)}"
    steps.join(", ")
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
