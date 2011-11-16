require 'nokogiri'

module RSpec::TagMatchers
  # Matches HTML tags by name.
  #
  # @modifier with_attribute
  #   Adds a criteria that an element must match the given attributes.
  #
  # @modifier with_criteria
  #   Adds an arbitrary criteria.
  #
  # @example Matching anchor tags
  #   it { should have_tag(:a) }
  #
  # @example Matching anchor tags that link to "/"
  #   it { should have_tag(:a).with_attribute(:href => "/") }
  #
  # @example Matching anchor tags with an even +id+ attribute
  #   it { should have_tag(:a).with_criteria { |elem| elem[:id].to_i.even? } }
  #
  # @return [HasTag]
  #
  # @see HasTag#with_attribute
  # @see HasTag#with_criteria
  def have_tag(name)
    HasTag.new(name)
  end

  # The base class for all tag matchers. HasTag is intended to provide facilities that are useful to
  # subclasses. The subclasses of HasTag should define more expressive tag matchers. For example, to
  # match a checkbox using HasTag directly, one would have to type:
  #
  #   it { has_tag(:input).with_attribute(:type => :checkbox) }
  #
  # That can all be encapsulated into a subclass that provides a more expressive matcher:
  #
  #   it { has_checkbox }
  #
  # == Element Matching
  #
  # The way tag matchers work is by counting how many elements match a set of filters. It starts by
  # finding element that match the given tag name, e.g., +a+, +div+, or +input+, and then filters
  # the list of matching elements according to a list of criteria. In the end, the matcher is left
  # with a set of elements that match *all* criteria. The matcher is said to match the input string
  # if the set of elements that match all its criteria contains at least one element. The matched
  # elements need not be the top-level element.
  #
  # === Example
  #
  # In this example, the matcher looks for +div+ elements with and +id+ of "foo" and a class of
  # "bar". An element must match all three of those criteria in order for the matcher to consider it
  # a successful match:
  #
  #   matcher = HasTag.new(:div).with_attribute(:id => :foo, :class => :bar)
  #   matcher.matches?('<div id="foo" class="bar"></div>')  # => true
  #   matcher.matches?('<div id="foo"></div>')              # => false
  #
  # However, the all criteria must be matched by <strong>the same</strong> element. If one element
  # matches half of the criteria and another element matches the other half of the criteria, it is
  # not considered a successful match:
  #
  #   matcher = HasTag.new(:div).with_attribute(:id => :foo, :class => :bar)
  #   matcher.matches?('<div id="foo"></div><div class="bar"></div>')   # => false
  #
  # == Subclassing HasTag
  #
  # In the most basic case, a subclass of HasTag will simply override the constructor to provide a
  # default tag name that must be matched. For example, a matcher to match +object+ tags might look
  # like this:
  #
  #   class HasObject < HasTag
  #     def initialize
  #       super(:object)
  #     end
  #   end
  #
  # Also, one should provide a helper method to construct the matcher inside of a spec. For the
  # above example, the helper method would look like this:
  #
  #   def have_object
  #     HasObject.new
  #   end
  #
  # This allows the user to construct a HasObject matcher by calling +have_object+ in his spec,
  # which provides for a more readable spec:
  #
  #   it { should have_object }
  #
  # In some cases it might make sense to add additional criteria from within the constructor or to
  # provide additional methods that can be chained from the matcher to provide tag-specific
  # criteria. See {HasTag#with_criteria} for how to add custom criteria to a matcher.
  class HasTag

    # Constructs a matcher that matches HTML tags by +name+.
    #
    # @param [String, Symbol] name  The type of tag to match.
    def initialize(name)
      @name       = name.to_s
      @attributes = {}
      @criteria   = []
    end

    # Answers whether or not the matcher matches any elements within +rendered+.
    #
    # @param [String] rendered    A string of HTML or an Object whose +to_s+ method returns HTML.
    #                             (That includes Nokogiri classes.)
    #
    # @return [Boolean]
    def matches?(rendered)
      Nokogiri::HTML::Document.parse(rendered.to_s).css(@name).select do |element|
        matches_attributes?(element) && matches_criteria?(element)
      end.length > 0
    end

    # Adds a constraint that the matched elements must match certain attributes.  The +attributes+
    # hash contains a set of key/value pairs. Each key is used for the attribute name (not case
    # sensitive) and the value is used to determine if an attribute matches according to the rules
    # in the following table:
    #
    # [Attribute Matching Values]
    #   String::  The attribute's value must match exactly.
    #   Symbol::  The attribute's value must match, but it is not case sensitive.
    #   Regexp::  The attribute's value must match the regular expression.
    #   true::    The attribute must exist. The attribute's value does not matter.
    #   false::   The attribute must *not* exist.
    #
    # @param [Hash]  attributes  A hash of attribute key/value pairs. The keys are the attribute
    #                             names.
    #
    # @return [self]
    def with_attribute(attributes)
      @attributes.merge!(attributes)
      self
    end
    alias :with_attributes :with_attribute

    # Adds an arbitrary criteria to the matched elements. The criteria can be a method name or a
    # block. The method or block should accept a single Nokogiri::XML::Node object as its argument
    # and return whether or not the element passed as an argument matches the criteria.
    #
    # @example
    #   have_div.with_criteria { |element| element[:id].to_i % 2 == 0 }
    #
    # @param  [Symbol]  method  The name of the method to be called.
    # @param  [Proc]    block   A block to be calle => d.
    #
    # @return [self]
    def with_criteria(method = nil, &block)
      @criteria << method   unless method.nil?
      @criteria << block    if block_given?
      self
    end

    protected

    # Tests with +attribute+ matches +expected+ according the the attribute matching rules described
    # in {#with_attribute}. This can be useful for testing attributes in subclasses.
    #
    # @note
    #   The reason this method receives a +Nokogiri::XML::Attr+ object instead of the attribute's
    #   value is that some attributes have meaning merely by existing, even if they don't have a
    #   value. For example, the +checked+ attribute of a checkbox or radio button does not need to
    #   have a value. If it doesn't have a value, +element[:checked]+ will return +nil+ in the JRuby
    #   implementation of Nokogiri, which would make <tt>with_attribute(:checked => true)</tt> fail
    #   in JRuby.
    #
    # @param [Nokogiri::XML::Attr]              attribute   The attribute to be tested.
    # @param [String, Symbol, Regexp, Boolean]  expected    The expected value of +attribute+.
    #
    # @return [Boolean]
    #
    # @see #with_attribute
    def test_attribute(attribute, expected)
      actual = attribute && attribute.value

      case expected
      when String
        actual == expected
      when Symbol
        actual =~ /^#{expected}$/i
      when Regexp
        actual =~ expected
      when true
        !attribute.nil?
      when false
        attribute.nil?
      end
    end

    private


    # Answers whether or not +element+ matches the attributes in the attributes hash given to
    # {#with_attribute}.
    #
    # @param [Nokogiri::XML::Node]  element   The element to be tested.
    #
    # @return [Boolean]
    def matches_attributes?(element) # :api: public
      @attributes.all? do |key, value|
        test_attribute(element.attribute(key.to_s), value)
      end
    end

    # Answers whether or not +element+ matches the custom criteria set by {#with_criteria}.
    #
    # @param [Nokogiri::XML::Node]  element   The element to be tested.
    #
    # @return [Boolean]
    def matches_criteria?(element)
      @criteria.all? do |method|
        case method
        when Symbol
          send(method, element)
        when Proc
          method.call(element)
        end
      end
    end
  end
end
