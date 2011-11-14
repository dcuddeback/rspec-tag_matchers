module RSpec::TagMatchers
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
