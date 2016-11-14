class Node
  attr_accessor :value, :parent, :left_child, :right_child

  def initialize(value=nil, parent=nil, left_child=nil, right_child=nil)
    @value = value
    @parent = parent
    @left_child = left_child
    @right_child = right_child
  end
end

# assumes array is sorted, returns binary tree of Nodes
# then refactor to handle data that isn't presorted can't be easily sorted
def build_tree(array)

end

# returns node at which target value is located using BFS
def breadth_first_search(target)

end

# returns node at which target vlaue is located using DFS
# use an array acting as stack
def depth_first_search(target)

end

# same as depth_first_search but using recursion
def dfs_rec

end
