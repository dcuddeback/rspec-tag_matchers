module RSpec::TagMatchers
  def have_form
    HasForm.new
  end

  class HasForm < HasTag
    def initialize
      super(:form)
    end
  end
end
