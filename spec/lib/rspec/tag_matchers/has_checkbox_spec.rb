require 'spec_helper'

describe RSpec::TagMatchers::HasCheckbox do
  include RSpec::TagMatchers

  describe "matching checkbox tags" do
    context "have_checkbox" do
      subject { have_checkbox }
      it { should_not match("<input />") }
      it { should     match("<input type='checkbox' />") }
      it { should     match("<input TYPE='CHECKBOX' />") }
      it { should_not match("<input type='text' />") }
      it { should_not match("<input type='checkboxer' />") }
      it { should_not match("input checkbox") }
    end
  end

  describe "matching checkbox state" do
    context "have_checkbox.checked" do
      subject { have_checkbox.checked }
      it      { should_not match("<input type='checkbox' />") }
      it      { should     match("<input type='checkbox' checked />") }
      it      { should     match("<input type='checkbox' checked='checked' />") }
      it      { should     match("<input type='checkbox' checked='1' />") }
    end

    context "have_checkbox.not_checked" do
      subject { have_checkbox.not_checked }
      it      { should     match("<input type='checkbox' />") }
      it      { should_not match("<input type='checkbox' checked />") }
      it      { should_not match("<input type='checkbox' checked='checked' />") }
      it      { should_not match("<input type='checkbox' checked='1' />") }
    end
  end

  describe "matching input names" do
    context "have_checkbox.for(:user => :admin)" do
      subject { have_checkbox.for(:user => :admin) }
      it      { should_not match("<input type='checkbox' />") }
      it      { should_not match("<input type='checkbox' name='user' />") }
      it      { should     match("<input type='checkbox' name='user[admin]' />") }
      it      { should_not match("<input type='checkbox' name='user[admin][root]' />") }
    end
  end
end
