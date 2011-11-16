module RSpec::TagMatchers
  # A matcher that matches multiple input elements. It is intended to serve as a base class for
  # building more specific matchers that must match multiple input elements. For example, a matcher
  # to test for Rails' +time_select+ drop-downs must test that the HTML contains a drop-down for
  # hours and another drop-down for minutes.
  #
  # @example Building a date matcher
  #   matcher = MultipleInputMatcher.new(
  #       1 => HasSelect.new,
  #       2 => HasSelect.new,
  #       3 => HasSelect.new
  #     )
  #   matcher.for(:user => :birthday) # will match <select> tags with names
  #                                   # "user[birthday(1i)]", "user[birthday(2i)]", and
  #                                   # "user[birthday(3i)]"
  #
  # @example Building a time matcher
  #   MultipleInputMatcher.new(       # by default, will match <select> tags with names by regular
  #       4 => HasSelect.new,         # expressions: /\(4i\)/ and /\(5i\)/
  #       5 => HasSelect.new
  #     )
  #
  #
  class MultipleInputMatcher

    # Initializes a matcher that matches multiple input elements.
    #
    # @param [Hash] components  A hash of matchers. The keys serve as indices and the values are the
    #                           matchers that must be satisfied.
    def initialize(components)
      @components = components
      @components.each do |index, matcher|
        matcher.with_attribute(:name => /\(#{index}i\)/)
      end
    end

    # Tests whether the matcher matches the +rendered+ string. It delegates matching to its
    # matchers. It returns true if all of its matchers return true. It returns false if *any* of its
    # matchers return false.
    #
    # @param [String] rendered  A string of HTML or an Object whose +to_s+ method returns HTML.
    #                           (That includes Nokogiri classes.)
    #
    # @return [Boolean]
    def matches?(rendered)
      @failures = matchers.reject do |matcher|
        matcher.matches?(rendered)
      end

      @failures.empty?
    end

    # Specifies the inputs names with more accuracy than the default regular expressions. It
    # delegates to each matcher's +for+ method. But it first appends the matcher's index to the last
    # component of the input's name.
    #
    # @example Input naming delegation
    #   hour_matcher   = HasSelect.new
    #   minute_matcher = HasSelect.new
    #   time_matcher   = MultipleInputMatcher.new(4 => hour_matcher, 5 => minute_matcher)
    #
    #   time_matcher.for(:event => :start_time) # calls hour_matcher.for("event", "start_time(4i)")
    #                                           # and minute_matcher.for("event", "start_time(5i)")
    #
    # @param [Array, Hash]  args  A hierarchy of string that specify the attribute name.
    #
    # @return [MultipleInputMatcher] self
    def for(*args)
      @components.each do |index, matcher|
        delegated_for(index, matcher, args)
      end
      self
    end

    # Returns the failure messages from each failed matcher.
    #
    # @return [String] Failure message
    def failure_message
      @failures.map(&:failure_message).join(" and ")
    end

    # Returns the negative failure messages from every matcher.
    #
    # @return [String] Negative failure message
    def negative_failure_message
      matchers.map(&:negative_failure_message).join(" and ")
    end

    private

    # Returns all the matchers.
    #
    # @return [Array] Matchers
    def matchers
      @components.values
    end

    # Set's +matcher+'s input name according to +args+ and +index+.
    #
    # @param [Integer]      index   The matcher's index.
    # @param [HasInput]     matcher The matcher.
    # @param [Arrah, Hash]  args    A hierarchy of names that would normally be passed to
    #                               {HasInput#for}.
    def delegated_for(index, matcher, args)
      args = args.dup
      args.extend(DeepFlattening)
      args = args.deep_flatten

      args[-1]  = args[-1].to_s
      args[-1] += "(#{index}i)"
      matcher.for(*args)
    end
  end
end
