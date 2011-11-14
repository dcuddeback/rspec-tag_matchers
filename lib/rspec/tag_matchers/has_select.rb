module RSpec::TagMatchers
  def have_select
    HasSelect.new
  end

  class HasSelect < HasInput
    def initialize
      super(:select)
    end
  end
end
