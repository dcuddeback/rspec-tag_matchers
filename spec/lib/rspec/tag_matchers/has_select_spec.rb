require 'spec_helper'

describe RSpec::TagMatchers::HasSelect do
  include RSpec::TagMatchers

  describe "matching select tags" do
    context "have_select" do
      subject { have_select }
      it { should_not match("<input />") }
      it { should     match("<select />") }
      it { should     match("<SELECT />") }
      it { should_not match("<selector />") }
      it { should_not match("select") }
    end
  end

  describe "matching input names" do
    context "have_select.for(:user => :role)" do
      subject { have_select.for(:user => :role) }
      it      { should_not match("<select />") }
      it      { should_not match("<select name='user' />") }
      it      { should     match("<select name='user[role]' />") }
      it      { should_not match("<select name='user[role][admin]' />") }
    end
  end
end
