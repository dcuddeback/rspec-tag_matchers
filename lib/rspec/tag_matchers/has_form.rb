module RSpec::TagMatchers
  # Matches <tt><form></tt> tags in HTML.
  #
  # @modifier with_verb
  #   Adds a criteria that the form must have the given HTTP verb.
  #
  # @modifier with_action
  #   Adds a criteria that the form must target the given URL as its action.
  #
  # @example Matching a simple form
  #   it { should have_form.with_verb(:post).with_action("/signup") }
  #
  # @example Matching a form with an overridden method
  #   it { should have_form.with_verb(:put) }
  #
  # @return [HasForm]
  #
  # @see HasForm#with_verb
  # @see HasForm#with_action
  def have_form
    HasForm.new
  end

  # A matcher that matches +<form>+ tags.
  class HasForm < HasTag

    # Initializes a HasForm matcher that matches +form+ elements.
    def initialize
      super(:form)
    end

    # Specifies that the form will use the given HTTP verb, following Rails conventions. It first
    # looks for a method override value (a hidden input named +_method+). If the method override
    # value doesn't exist, then it looks for the +method+ attribute on the +form+ tag. Whichever
    # value it finds will be compared to the value passed in as the +verb+ argument to +with_verb+.
    #
    # @param [Symbol] verb  An HTTP verb, e.g., :get, :post, :put, or :delete.
    #
    # @return [HasForm] self
    def with_verb(verb)
      with_criteria do |element|
        matches_verb?(element, verb)
      end
    end
    alias :with_method :with_verb

    # Specifies that the form must target the given URL as its action. It compares the +action+
    # attribute on the +form+ tag to the +action+ argument passed to +with_action+.
    #
    # @param [String, Regexp] action  The URL that the form should target.
    #
    # @return [HasForm] self
    def with_action(action)
      with_attribute(:action => action)
    end

    private

    # Tests whether +element+ will use the given HTTP +verb+.
    #
    # @param [Nokogiri::XML::Node]  element A +form+ element to be tested.
    # @param [Symbol]               verb    An HTTP verb (:get, :post, :put, etc).
    #
    # @return [Boolean]
    def matches_verb?(element, verb)
      test_attribute(form_method(element), verb)
    end

    # Returns the attribute that specifies which HTTP verb the form will use. It considers a method
    # override value as well as the +form+ tag's +method+ attribute.
    #
    # @param [Nokogiri::XML::Node]  element A +form+ element to be tested.
    #
    # @return [Nokogiri::XML::Attr] The attribute that specifies the HTTP verb.
    def form_method(element)
      method_override(element) || element.attribute("method")
    end

    def method_override(element)
      override = element.css("input[type=hidden][name=_method]")
      override && override.first && override.attribute("value")
    end
  end
end
