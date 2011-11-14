require 'deep_flattening'

module RSpec::TagMatchers
  def have_input
    HasInput.new
  end

  class HasInput < HasTag
    def initialize(name = :input)
      super
    end

    def for(*args)
      with_attribute(:name => build_name(*args))
      self
    end

    private

    # Convert array or hash of names to a name for an input form.
    #
    # Examples:
    #
    #   build_name(:foo => :bar)            # => "foo[bar]"
    #   build_name(:foo, :bar)              # => "foo[bar]"
    #   build_name(:foo => {:bar => :baz})  # => "foo[bar][baz]"
    #   build_name(:foo, :bar => :baz)      # => "foo[bar][baz]"
    def build_name(*args)
      args.extend(DeepFlattening)
      args = args.deep_flatten
      name = args.shift.to_s
      name + args.map {|piece| "[#{piece}]"}.join
    end
  end
end
