module ServiceTypesHelper
  def display_children(parent)
    puts parent.children.map {|child| child.name }.join(", " )
  end
 
 
  def tree_ul(acts_as_tree_set, init=true, &block)
    if acts_as_tree_set.size > 0
      ret = '<ul>'
      acts_as_tree_set.collect do |item|
        next if item.parent_id && init
        ret += '<li>'
        ret += yield item
        ret += tree_ul(item.direct_children, false, &block) if item.children_count > 0
        ret += '</li>'
      end
      ret += '</ul>'
    end
  end
end
