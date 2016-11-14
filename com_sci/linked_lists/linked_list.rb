class LinkedList # zero indexed
  attr_accessor :list_name

  def initialize(value=nil)
    if value.nil?
      @head = nil
      @tail = nil
    else
      entry = Node.new(value)
      @head = entry
      @tail = entry
    end
  end

  def each
    return nil if @head.nil?
    entry = @head
    until entry.nil?
      yield entry
      entry = entry.next_node
    end
  end

  def append(value) # returns full linked list
    if @head.nil?
      entry = Node.new(value)
      @head = entry
      @tail = entry
    else
      entry = Node.new(value)
      @tail.next_node = entry
      @tail = entry
    end
    self.to_s
  end

  def prepend(value) # returns full linked list
    if @head.nil?
      entry = Node.new(value)
      @head = entry
      @tail = entry
    else
      entry = Node.new(value)
      entry.next_node = @head
      @head = entry
    end
    self.to_s
  end

  def size
    count = 0
    self.each { |entry| count += 1 }
    count
  end

  def head
    @head.value.to_s
  end

  def tail
    @tail.value.to_s
  end

  def at(search_index) # returns node
    entry_index = 0

    self.each do |entry|
      return entry if entry_index == search_index
      entry_index += 1
    end
    nil
  end

  def pop # deletes last node and returns it to console
    popped = self.return_pop
    new_tail = self.at(self.size - 2)
    new_tail.next_node = nil
    @tail = new_tail
    popped
  end

  def return_pop
    popped = ""
    self.each { |entry| popped << entry.value if entry.next_node == nil }
    popped
  end

  def contains?(value) #returns boolean
    self.each { |entry| return true if entry.value == value }
    false
  end

  def find(data) # returns index
    entry_index = 0

    self.each do |entry|
      return entry_index if entry.value == data
      entry_index += 1
    end

    nil
  end

  def to_s # returns full list
    list = []
    self.each { |entry| list << entry.value }
    list.join(" -> ") + " -> nil"
  end

  def insert_at(index, data) # inserts after index
    target_index = self.at(index)
    new_entry = Node.new(data)

    new_entry.next_node = target_index.next_node
    target_index.next_node = new_entry
  end

  def remove_at(index) # removes node at index and returns it, like pop
    target= self.at(index)
    prev = self.at(index - 1)
    after = self.at(index + 1)

    return nil if target.nil?

    if target == @tail
      self.pop
    elsif target == @head
      @head = after
    else
      prev.next_node = after
    end
    target.next_node = nil
    target.value
  end

  class Node
    attr_accessor :value, :next_node

    def initialize(value=nil, next_node=nil)
      @value = value
      @next_node = next_node
    end
  end

end
