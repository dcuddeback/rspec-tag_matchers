module RSpec::TagMatchers
  # Matches <tt><input type="checkbox"></tt> tags in HTML.
  #
  # @modifier checked
  #   Specifies that the checkbox must be checked.
  #
  # @modifier not_checked
  #   Specifies that the checkbox must *not* be checked.
  #
  # @example Matching a checked checkbox for +terms_of_service+
  #   it { should have_checkbox.for(:terms_of_service).checked }
  #
  # @example Matching an unchecked checkbox for +terms_of_service+
  #   it { should have_checkbox.for(:terms_of_service).not_checked }
  #
  # @return [HasCheckbox]
  #
  # @see HasCheckbox.checked
  # @see HasCheckbox.not_checked
  def have_checkbox
    HasCheckbox.new
  end

  class HasCheckbox < HasInput
    def initialize
      super
      with_attribute(:type => :checkbox)
    end

    def checked
      with_attribute(:checked => true)
      self
    end

    def not_checked
      with_attribute(:checked => false)
      self
    end
  end
end
