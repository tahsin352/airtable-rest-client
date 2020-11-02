class Hash
  def apply_diff(changes, direction = :right)
    cloned = self.clone
    path = [[cloned, changes]]
    pos, local_changes = path.pop
    while local_changes
      local_changes.each_pair {|key, change|
        if change.kind_of?(Array)
          pos[key] = (direction == :right) ? change[1] : change[0]
        else
          pos[key] = pos[key].clone
          path.push([pos[key], change])
        end
      }
      pos, local_changes = path.pop
    end
    cloned
  end
  def deep_diff(other)
    (self.keys + other.keys).uniq.inject({}) do |memo, key|
      left = self[key]
      right = other[key]

      next memo if left == right

      if left.respond_to?(:deep_diff) && right.respond_to?(:deep_diff)
        memo[key] = left.deep_diff(right)
      else
        memo[key] = [left, right]
      end

      memo
    end
  end

  def deep_diff1(other)
    (self.keys + other.keys).uniq.inject({}) do |memo, key|
      left = self[key]
      right = other[key]

      next memo if left == right

      if left.respond_to?(:deep_diff) && right.respond_to?(:deep_diff)
        memo[key] = left.deep_diff(right)
      else
        memo[key] = [left, right]
      end

      memo
    end
  end

  def diff(other)
    dup.
      delete_if { |k, v| other[k] == v }.
      merge!(other.dup.delete_if { |k, v| has_key?(k) })
  end
end

class Array
  def deep_diff(array)
    largest = [self.count, array.count].max
    memo = {}

    0.upto(largest - 1) do |index|
      left = self[index]
      right = array[index]

      next if left == right

      if left.respond_to?(:deep_diff) && right.respond_to?(:deep_diff)
        memo[index] = left.deep_diff(right)
      else
        memo[index] = [left, right]
      end
    end

    memo
  end
end