module RSpec::TagMatchers
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

    def with_action(action)
      with_attribute(:action => action)
    end

    private

    def matches_verb?(element, verb)
      test_attribute(form_method(element), verb)
    end

    def form_method(element)
      method_override(element) || element[:method]
    end

    def method_override(element)
      override = element.css("input[type=hidden][name=_method]")
      override && override.first && override.first[:value]
    end
  end
end
