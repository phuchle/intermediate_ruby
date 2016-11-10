def merge_sort(array)
  if array.length == 1
    return array
  else
    midpoint = (array.length / 2.0).round

    left_array = array[0...midpoint]
    right_array = array[midpoint..-1]

    left_sorted = merge_sort(left_array)
    right_sorted = merge_sort(right_array)

    merge(left_sorted, right_sorted)
  end
end

def merge(left_sorted, right_sorted)
  result = []
  total_length = left_sorted.length + right_sorted.length

  while result.length < total_length
    if left_sorted.empty?
      until right_sorted.empty?
        result << right_sorted.shift
      end
    elsif right_sorted.empty?
      until left_sorted.empty?
        result << left_sorted.shift
      end
    elsif left_sorted[0] == right_sorted[0]
      result.push(left_sorted.shift, right_sorted.shift)
    elsif left_sorted[0] < right_sorted[0]
      result << left_sorted.shift
    elsif right_sorted[0] < left_sorted[0]
      result << right_sorted.shift
    end
  end
  result
end
