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

  # A matcher that matches <tt><input type="checkbox"></tt> tags.
  class HasCheckbox < HasInput

    # Initializes a HasCheckbox matcher that matches elements named +input+ with a +type+ attribute
    # of +checkbox+.
    def initialize
      super
      with_attribute(:type => :checkbox)
    end

    # Specifies that the checkbox must be selected. A checkbox is considered to be checked if it has
    # a +checked+ attribute.
    #
    # @example Checkboxes which are considered checked
    #   <input type="checkbox" checked="checked" />
    #   <input type="checkbox" checked="1" />
    #   <input type="checkbox" checked />
    #
    # @return [HasCheckbox] self
    def checked
      with_attribute(:checked => true)
      self
    end

    # Specifies that the checkbox must *not* be selected. A checkbox is not checked if it has no
    # +checked+ attribute.
    #
    # @example An unchecked checkbox
    #   <input type="checkbox" />
    #
    # @return [HasCheckbox] self
    def not_checked
      with_attribute(:checked => false)
      self
    end
  end
end
