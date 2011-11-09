require 'spec_helper'

describe RSpec::TagMatchers::HasForm do
  include RSpec::TagMatchers

  describe "matching form tags" do
    context "have_form" do
      subject { have_form }
      it      { should     match("<form></form>") }
      it      { should     match("<form method='POST'></form>") }
      it      { should     match("<FORM></FORM>") }
      it      { should_not match("<foo></foo>") }
      it      { should_not match("<former></former>") }
      it      { should_not match("form") }
    end
  end
end
