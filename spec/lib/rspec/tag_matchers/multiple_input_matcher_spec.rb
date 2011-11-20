require 'spec_helper'

describe RSpec::TagMatchers::MultipleInputMatcher do
  let(:foo_matcher) { mock("'foo' input matcher") }
  let(:bar_matcher) { mock("'bar' input matcher") }
  let(:html)        { "<input name='foo' /><input name='bar' />" }

  let(:multiple_matcher) do
    RSpec::TagMatchers::MultipleInputMatcher.new('2i' => foo_matcher, '3i' => bar_matcher)
  end

  before do
    # prevent unexpected messages from causing test failures
    foo_matcher.stub(:with_attribute).with(:name => /\(2i\)/)
    bar_matcher.stub(:with_attribute).with(:name => /\(3i\)/)
  end

  describe "#initialize" do
    it "should add criteria for input indices" do
      foo_matcher.should_receive(:with_attribute).with(:name => /\(2i\)/)
      bar_matcher.should_receive(:with_attribute).with(:name => /\(3i\)/)
      multiple_matcher
    end
  end

  describe "#for" do
    it "should add indices, e.g., '(2i)', to last part of each input's name" do
      foo_matcher.should_receive(:for).with("example", "foobar(2i)")
      bar_matcher.should_receive(:for).with("example", "foobar(3i)")
      multiple_matcher.for("example" => "foobar")
    end

    it "should return self" do
      foo_matcher.should_receive(:for)
      bar_matcher.should_receive(:for)
      multiple_matcher.for("example" => "foobar").should == multiple_matcher
    end
  end

  describe "#matches?" do
    context "all matchers pass" do
      before do
        foo_matcher.should_receive(:matches?).with(html).and_return(true)
        bar_matcher.should_receive(:matches?).with(html).and_return(true)
      end

      subject { multiple_matcher.matches?(html) }
      it      { should be_true }
    end

    context "some matchers fail" do
      before do
        foo_matcher.should_receive(:matches?).with(html).and_return(false)
        bar_matcher.should_receive(:matches?).with(html).and_return(true)
      end

      subject { multiple_matcher.matches?(html) }
      it      { should be_false }
    end

    context "all matchers fail" do
      before do
        foo_matcher.should_receive(:matches?).with(html).and_return(false)
        bar_matcher.should_receive(:matches?).with(html).and_return(false)
      end

      subject { multiple_matcher.matches?(html) }
      it      { should be_false }
    end
  end

  describe "#failure_message" do
    let(:failure_message_for_foo) { "failure message for foo" }
    let(:failure_message_for_bar) { "failure message for bar" }

    context "foo_matcher fails" do
      before do
        foo_matcher.should_receive(:matches?).with(html).and_return(false)
        bar_matcher.should_receive(:matches?).with(html).and_return(true)
        multiple_matcher.matches?(html)

        foo_matcher.should_receive(:failure_message).and_return(failure_message_for_foo)
      end

      subject { multiple_matcher.failure_message }
      it      { should == failure_message_for_foo }
    end

    context "bar_matcher fails" do
      before do
        foo_matcher.should_receive(:matches?).with(html).and_return(true)
        bar_matcher.should_receive(:matches?).with(html).and_return(false)
        multiple_matcher.matches?(html)

        bar_matcher.should_receive(:failure_message).and_return(failure_message_for_bar)
      end

      subject { multiple_matcher.failure_message }
      it      { should == failure_message_for_bar }
    end

    context "all matchers fail" do
      before do
        foo_matcher.should_receive(:matches?).with(html).and_return(false)
        bar_matcher.should_receive(:matches?).with(html).and_return(false)
        multiple_matcher.matches?(html)

        foo_matcher.should_receive(:failure_message).and_return(failure_message_for_foo)
        bar_matcher.should_receive(:failure_message).and_return(failure_message_for_bar)
      end

      subject { multiple_matcher.failure_message }
      it      { should include(failure_message_for_foo) }
      it      { should include(failure_message_for_bar) }
      it      { should include(" and ") }
    end
  end

  describe "#negative_failure_message" do
    let(:negative_failure_message_for_foo) { "negative failure message for foo" }
    let(:negative_failure_message_for_bar) { "negative failure message for bar" }

    context "all matchers pass" do
      before do
        foo_matcher.should_receive(:matches?).with(html).and_return(true)
        bar_matcher.should_receive(:matches?).with(html).and_return(true)
        multiple_matcher.matches?(html)

        foo_matcher.should_receive(:negative_failure_message).and_return(negative_failure_message_for_foo)
        bar_matcher.should_receive(:negative_failure_message).and_return(negative_failure_message_for_bar)
      end

      subject { multiple_matcher.negative_failure_message }
      it      { should include(negative_failure_message_for_foo) }
      it      { should include(negative_failure_message_for_bar) }
      it      { should include(" and ") }
    end
  end
end
