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

  describe "matching form methods" do
    context "have_form.with_verb(:get)" do
      subject { have_form.with_verb(:get) }
      it      { should_not match("<form></form>") }
      it      { should     match("<form method='GET'></form>") }
      it      { should     match("<form method='get'></form>") }
      it      { should_not match("<form method='POST'></form>") }
    end

    context "have_form.with_verb(:post)" do
      subject { have_form.with_verb(:post) }
      it      { should_not match("<form></form>") }
      it      { should_not match("<form method='GET'></form>") }
      it      { should     match("<form method='POST'></form>") }
      it      { should     match("<form method='post'></form>") }
      it      { should_not match("<form method='post'><input type='hidden' name='_method' value='put' /></form>") }
      it      { should_not match("<form method='post'><input type='hidden' name='_method' value='PUT' /></form>") }
    end

    context "have_form.with_verb(:put)" do
      subject { have_form.with_verb(:put) }
      it      { should_not match("<form></form>") }
      it      { should_not match("<form method='POST'></form>") }
      it      { should_not match("<form method='post'></form>") }
      it      { should     match("<form method='post'><input type='hidden' name='_method' value='put' /></form>") }
      it      { should     match("<form method='post'><input type='hidden' name='_method' value='PUT' /></form>") }
    end
  end

  describe "matching form actions" do
    context "have_form.with_action('/foobar')" do
      subject { have_form.with_action("/foobar") }
      it      { should_not match("<form></form>") }
      it      { should     match("<form action='/foobar'></form>") }
      it      { should_not match("<form action='/foobarz'></form>") }
      it      { should_not match("<form action='/baz'></form>") }
    end
  end
end
