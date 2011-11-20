require 'spec_helper'

describe RSpec::TagMatchers::HasInput do
  include RSpec::TagMatchers

  describe "matching input tags" do
    context "have_input" do
      subject { have_input }
      it      { should     match("<input />") }
      it      { should     match("<input type='text' />") }
      it      { should     match("<INPUT />") }
      it      { should_not match("<inputer />") }
      it      { should_not match("input") }
    end
  end

  describe "matching input names" do
    context "have_input.for(:user => :name)" do
      subject { have_input.for(:user => :name) }
      it      { should_not match("<input />") }
      it      { should     match("<input name='user[name]' />") }
      it      { should_not match("<input name='user[name][first]' />") }
    end

    context "have_input.for(:user, :name)" do
      subject { have_input.for(:user, :name) }
      it      { should_not match("<input />") }
      it      { should     match("<input name='user[name]' />") }
      it      { should_not match("<input name='user[name][first]' />") }
    end

    context "have_input.for(:user => {:name => :first})" do
      subject { have_input.for(:user => {:name => :first}) }
      it      { should_not match("<input />") }
      it      { should_not match("<input name='user[name]' />") }
      it      { should     match("<input name='user[name][first]' />") }
    end

    context "have_input.for(:user, :name => :first)" do
      subject { have_input.for(:user, :name => :first) }
      it      { should_not match("<input />") }
      it      { should_not match("<input name='user[name]' />") }
      it      { should     match("<input name='user[name][first]' />") }
    end

    context "have_input.for(:user, :name, :first)" do
      subject { have_input.for(:user, :name, :first) }
      it      { should_not match("<input />") }
      it      { should_not match("<input name='user[name]' />") }
      it      { should     match("<input name='user[name][first]' />") }
    end
  end

  describe "matching input values" do
    context "have_input.value(:foo)" do
      subject { have_input.value(:foo) }
      it      { should     match("<input value='foo' />") }
      it      { should_not match("<input value='bar' />") }
      it      { should_not match("<input />") }
    end
  end
end
