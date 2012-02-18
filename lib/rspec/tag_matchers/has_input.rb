require 'deep_flattening'

module RSpec::TagMatchers
  # Matches <tt><input></tt> tags in HTML.
  #
  # @modifier for
  #   Adds a criteria that the input must be for the given attribute.
  #
  # @modifier value
  #   Adds a criteria that the input must have a given value.
  #
  # @example Matching an input for the +name+ attribute on +user+
  #   it { should have_input.for(:user => :name) }
  #   it { should have_input.for(:user, :name) }
  #
  # @example Matching an input with a value of <tt>"42"</tt>.
  #   it { should have_input.value("42") }
  #
  # @return [HasInput]
  #
  # @see HasInput#for
  def have_input
    HasInput.new
  end

  # A base class for form input matchers.
  #
  # == Subclassing
  #
  # HasInput is intended to be subclassed to create more expressive matchers for specific types of
  # form inputs. The helper methods in HasInput, e.g., {#for}, are intended to be useful for all
  # types of form inputs.
  #
  # By default, HasInput matches +<input>+ elements, but this can be overridden by subclasses, e.g.,
  # HasSelect matches +<select>+ elements. This can be done in the matcher's constructor:
  #
  #   class HasSelect < HasInput
  #     def initialize
  #       super(:select)
  #     end
  #   end
  #
  # Some matchers might want to add more criteria inside their constructors. For example, matchers
  # that match specific types of +<input>+ tags will want to add a criteria for matching the +type+
  # attribute:
  #
  #   class HasCheckbox < HasInput
  #     def initialize
  #       super(:checkbox)
  #       with_attribute(:type => :checkbox)
  #     end
  #   end
  #
  #
  class HasInput < HasTag

    # Initializes a HasInput matcher that matches elements named +name+.
    #
    # @param [Symbol] name  The type of HTML tag to match.
    def initialize(name = :input)
      super
    end

    # Adds a criteria that the input tag should be for a given attribute.
    #
    # HasInput provides the {#for} modifier to all of its subclasses, which is useful for matching
    # the input's name with Rails conventions. For example, a Rails template that uses +form_for+
    # might output HTML that looks like this:
    #
    #   <form method="POST" action="/users">
    #     <input type="text" name="user[name]" />
    #   </form>
    #
    # Instead of writing:
    #
    #   it { should have_input.with_attribute(:name => "user[name]") }
    #
    # the user can write a more concise spec using {#for}:
    #
    #   it { should have_input.for(:user => :name) }
    #
    # @example Match an input for the +name+ attribute of +user+
    #   it { should have_input.for(:user => :name) }
    #
    # @example Match an input for a nested attribute
    #   it { should have_input.for(:user => {:role => :admin}) }
    #   it { should have_input.for(:user, :role => :admin) }
    #
    # @param [Array, Hash]  args  A hierarchy of strings that specifiy the attribute name.
    #
    # @return [HasInput] self
    def for(*args)
      with_attribute(:name => build_name(*args))
      self
    end

    # Adds a criteria that the input's value must match a certain value.
    #
    # @param [String, Symbol, Regexp, true, false]  value
    #
    # @return [HasInput] self
    def value(value)
      with_attribute(:value => value)
    end

    private

    # Converts an array or hash of names to a name for an input form.
    #
    # @example
    #   build_name(:foo => :bar)            # => "foo[bar]"
    #   build_name(:foo, :bar)              # => "foo[bar]"
    #   build_name(:foo => {:bar => :baz})  # => "foo[bar][baz]"
    #   build_name(:foo, :bar => :baz)      # => "foo[bar][baz]"
    #
    # @param [Array, Hash]  args  A hierarchy of strings.
    #
    # @return [String] The expected name of the form input.
    def build_name(*args)
      args.extend(DeepFlattening)
      args = args.deep_flatten
      name = args.shift.to_s
      name + args.map {|piece| "[#{piece}]"}.join
    end
  end
end
