module RSpec::TagMatchers::Helpers
  module SentenceHelper
    # Joins multiple strings into a sentence with punctuation and conjunctions.
    #
    # @example Forming sentences
    #   make_sentence("foo")                # => "foo"
    #   make_sentence("foo", "bar")         # => "foo and bar"
    #   make_sentence("foo", "bar", "baz")  # => "foo, bar, and baz"
    #
    # @example Overriding the conjunction
    #   make_sentence("foo", "bar", "baz", :conjunction => "or")  # => "foo, bar, or baz"
    #
    # @param [Strings] *strings   A list of strings to be combined into a sentence. The last item
    #                             can be an options hash.
    #
    # @option *strings.last [String] :conjunction ("and")   The conjunction to use to join sentence
    #                                                       fragments.
    #
    # @return [String]
    def make_sentence(*strings)
      options     = strings.last.is_a?(Hash) ? strings.pop : {}
      strings     = strings.flatten.map(&:to_s).reject(&:empty?)
      conjunction = options[:conjunction] || "and"

      case strings.count
      when 0
        ""
      when 1
        strings.first
      else
        last       = strings.pop
        puncuation = strings.count > 1 ? ", " : " "

        [strings, "#{conjunction} #{last}"].flatten.join(puncuation)
      end
    end
  end
end
