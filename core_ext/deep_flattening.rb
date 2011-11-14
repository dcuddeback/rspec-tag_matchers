# Mixin for Array and Hash objects to allow deep flattening of heterogeneous
# data structures.
module DeepFlattening
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
