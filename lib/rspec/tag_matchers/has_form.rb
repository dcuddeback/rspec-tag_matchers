module RSpec::TagMatchers
  # Matches +<form>+ tags in HTML.
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

  class HasForm < HasTag
    def initialize
      super(:form)
    end

    def with_verb(verb)
      with_criteria do |element|
        matches_verb?(element, verb)
      end
    end
    alias :with_method :with_verb

    def with_action(action)
      with_attribute(:action => action)
    end

    private

    def matches_verb?(element, verb)
      test_attribute(form_method(element), verb)
    end

    def form_method(element)
      method_override(element) || element.attribute("method")
    end

    def method_override(element)
      override = element.css("input[type=hidden][name=_method]")
      override && override.first && override.attribute("value")
    end
  end
end
