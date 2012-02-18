module RSpec::TagMatchers
  # Matches <tt><select></tt> tags in HTML.
  #
  # @example Matching a select tag for a user's role
  #   it { should have_select.for(:user => :role) }
  #
  # @return [HasSelect]
  def have_select
    HasSelect.new
  end

  # A matcher that matches +<select>+ tags.
  class HasSelect < HasInput

    # Initializes a HasSelect matcher that matches +select+ elements.
    def initialize
      super(:select)
    end
  end
end
