require 'spec_helper'

describe RSpec::TagMatchers::HasTag do
  include RSpec::TagMatchers

  describe "tag name matching" do
    context "matches with symbol" do
      context 'have_tag(:foo)' do
        subject { have_tag(:foo) }
        it      { should     match("<foo></foo>") }
        it      { should     match("<foo bar='baz'></foo>") }
        it      { should     match("<FOO></FOO>") }
        it      { should_not match("<foobar></foobar>") }
        it      { should_not match("<bar></bar>") }
        it      { should_not match("foo") }
      end

      context 'have_tag(:bar)' do
        subject { have_tag(:bar) }
        it      { should     match("<bar></bar>") }
        it      { should_not match("<foo></foo>") }
      end
    end

    context "matches with string" do
      context 'have_tag("foo")' do
        subject { have_tag("foo") }
        it      { should     match("<foo></foo>") }
        it      { should     match("<foo bar='1'></foo>") }
        it      { should     match("<FOO></FOO>") }
        it      { should_not match("<foobar></foobar>") }
        it      { should_not match("<bar></bar>") }
        it      { should_not match("foo") }
      end

      context 'have_tag("bar")' do
        subject { have_tag("bar") }
        it      { should     match("<bar></bar>") }
        it      { should_not match("<foo></foo>") }
      end
    end
  end

  describe "attribute value matching" do
    context "true matches presence of attribute" do
      context 'have_tag(:foo).with_attribute(:bar => true)' do
        subject { have_tag(:foo).with_attribute(:bar => true) }
        it      { should_not match("<foo></foo>") }
        it      { should     match("<foo bar='baz'></foo>") }
        it      { should     match("<foo bar='qux'></foo>") }
        it      { should_not match("<foo qux='baz'></foo>") }
        it      { should_not match("<foo>bar</foo>") }
        it      { should_not match("<foo></foo><qux bar='baz'></qux>") }
      end

      context 'have_tag(:foo).with_attribute(:qux => true)' do
        subject { have_tag(:foo).with_attribute(:qux => true) }
        it      { should_not match("<foo></foo>") }
        it      { should_not match("<foo bar='baz'></foo>") }
        it      { should     match("<foo qux='baz'></foo>") }
        it      { should_not match("<foo></foo><qux bar='baz'></qux>") }
      end
    end

    context "false matches absence of attribute" do
      context 'have_tag(:foo).with_attribute(:bar => false)' do
        subject { have_tag(:foo).with_attribute(:bar => false) }
        it      { should     match("<foo></foo>") }
        it      { should_not match("<foo bar='baz'></foo>") }
        it      { should_not match("<foo bar='qux'></foo>") }
        it      { should     match("<foo qux='baz'></foo>") }
      end

      context 'have_tag(:foo).with_attribute(:qux => false)' do
        subject { have_tag(:foo).with_attribute(:qux => false) }
        it      { should     match("<foo></foo>") }
        it      { should     match("<foo bar='baz'></foo>") }
        it      { should_not match("<foo qux='baz'></foo>") }
      end
    end

    context "string matches exactly" do
      context 'have_tag(:foo).with_attribute(:bar => "baz")' do
        subject { have_tag(:foo).with_attribute(:bar => "baz") }
        it      { should_not match("<foo></foo>") }
        it      { should     match("<foo bar='baz'></foo>") }
        it      { should_not match("<foo bar='qux'></foo>") }
        it      { should_not match("<foo bar='BAZ'></foo>") }
        it      { should_not match("<foo bar='baza'></foo>") }
        it      { should_not match("<foo bar='abaz'</foo>") }
        it      { should_not match("<foo qux='baz'></foo>") }
      end

      context 'have_tag(:foo).with_attribute(:bar => "qux")' do
        subject { have_tag(:foo).with_attribute(:bar => "qux") }
        it      { should_not match("<foo></foo>") }
        it      { should_not match("<foo bar='baz'></foo>") }
        it      { should     match("<foo bar='qux'></foo>") }
        it      { should_not match("<foo qux='baz'></foo>") }
      end

      context 'have_tag(:foo).with_attribute(:qux => "baz")' do
        subject { have_tag(:foo).with_attribute(:qux => "baz") }
        it      { should_not match("<foo></foo>") }
        it      { should_not match("<foo bar='baz'></foo>") }
        it      { should_not match("<foo bar='qux'></foo>") }
        it      { should     match("<foo qux='baz'></foo>") }
      end
    end

    context "symbol matches ignoring case" do
      context 'have_tag(:foo).with_attribute(:bar => :baz)' do
        subject { have_tag(:foo).with_attribute(:bar => :baz) }
        it      { should_not match("<foo></foo>") }
        it      { should     match("<foo bar='baz'></foo>") }
        it      { should     match("<foo bar='BAZ'></foo>") }
        it      { should_not match("<foo bar='qux'></foo>") }
        it      { should_not match("<foo bar='baza'></foo>") }
        it      { should_not match("<foo bar='abaz'</foo>") }
        it      { should_not match("<foo qux='baz'></foo>") }
      end

      context 'have_tag(:foo).with_attribute(:bar => :qux)' do
        subject { have_tag(:foo).with_attribute(:bar => :qux) }
        it      { should_not match("<foo></foo>") }
        it      { should_not match("<foo bar='baz'></foo>") }
        it      { should     match("<foo bar='qux'></foo>") }
        it      { should_not match("<foo qux='baz'></foo>") }
      end

      context 'have_tag(:foo).with_attribute(:qux => :baz)' do
        subject { have_tag(:foo).with_attribute(:qux => :baz) }
        it      { should_not match("<foo></foo>") }
        it      { should_not match("<foo bar='baz'></foo>") }
        it      { should_not match("<foo bar='qux'></foo>") }
        it      { should     match("<foo qux='baz'></foo>") }
      end
    end

    context "regex matches with regex" do
      context 'have_tag(:foo).with_attribute(:bar => /baz/)' do
        subject { have_tag(:foo).with_attribute(:bar => /baz/) }
        it      { should_not match("<foo></foo>") }
        it      { should     match("<foo bar='baz'></foo>") }
        it      { should_not match("<foo bar='BAZ'></foo>") }
        it      { should_not match("<foo bar='qux'></foo>") }
        it      { should     match("<foo bar='baza'></foo>") }
        it      { should     match("<foo bar='abaz'</foo>") }
        it      { should_not match("<foo qux='baz'></foo>") }
      end

      context 'have_tag(:foo).with_attribute(:bar => /qux/)' do
        subject { have_tag(:foo).with_attribute(:bar => /qux/) }
        it      { should_not match("<foo></foo>") }
        it      { should_not match("<foo bar='baz'></foo>") }
        it      { should     match("<foo bar='qux'></foo>") }
        it      { should_not match("<foo qux='baz'></foo>") }
      end

      context 'have_tag(:foo).with_attribute(:qux => /baz/)' do
        subject { have_tag(:foo).with_attribute(:qux => /baz/) }
        it      { should_not match("<foo></foo>") }
        it      { should_not match("<foo bar='baz'></foo>") }
        it      { should_not match("<foo bar='qux'></foo>") }
        it      { should     match("<foo qux='baz'></foo>") }
      end
    end

    context "matches multiple attributes" do
      context 'have_tag(:foo).with_attribute(:bar => true, :baz => true)' do
        subject { have_tag(:foo).with_attribute(:bar => true, :baz => true) }
        it      { should     match("<foo bar='1' baz'2'></foo>") }
        it      { should_not match("<foo bar='1'></foo>") }
        it      { should_not match("<foo baz='2'></foo>") }
        it      { should_not match("<foo></foo>") }
      end
    end
  end
end
