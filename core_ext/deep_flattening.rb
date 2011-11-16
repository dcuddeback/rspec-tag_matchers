# Mixin for Array and Hash objects that allows deep flattening of nested, heterogeneous data
# structures. Since it is only intended for internal use within this library, it is meant to extend
# existing Array or Hash objects instead of being included in the Array or Hash classes. This avoids
# inconsistencies between test and production environments by not affecting hashes or arrays in the
# user's codebase.
#
# @example
#   hash = {:foo => {:bar => [1, [2], :baz]}}
#   hash.respond_to?(:deep_flatten)   # => false
#   hash.extend(DeepFlattening)
#   hash.respond_to?(:deep_flatten)   # => true
#
#   hash.deep_flatten   # => [:foo, :bar, 1, 2, :baz]
#
#   array = [1, [2, {:foo => {:bar => [3, 4]}}, 5]
#   array.respond_to?(:deep_flatten)  # => false
#   array.extend(DeepFlattening)
#   array.respond_to?(:deep_flatten)  # => true
#
#   array.deep_flatten  # => [1, 2, :foo, :bar, 3, 4, 5]
module DeepFlattening
  # Flattens a nested, heterogeneous data structure to an array.
  def deep_flatten
    # Could be called on an array or a hash. Hashes in 1.9 have a flatten
    # method, but hashes in 1.8 do not. Therefor, we must call Hash#to_a before
    # we can flatten the hash in a compatible way.
    to_a.flatten.map do |object|
      case object
      when Array, Hash
        object.extend(DeepFlattening)
        object.deep_flatten
      else
        object
      end
    end.flatten
  end
end
