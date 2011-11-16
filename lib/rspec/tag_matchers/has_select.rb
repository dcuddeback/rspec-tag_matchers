module RSpec::TagMatchers
  # Matches +<select>+ tags in HTML.
  #
  # @example Matching a select tag for a user's role
  #   it { should have_select.for(:user => :role) }
  #
  # @return [HasSelect]
  def have_select
    HasSelect.new
  end

  class HasSelect < HasInput
    def initialize
      super(:select)
    end
  end
end
