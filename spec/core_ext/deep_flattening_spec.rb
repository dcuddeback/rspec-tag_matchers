require 'spec_helper'

RSpec::Matchers.define :flatten_to do |expected|
  match do |subject|
    actual = subject.deep_flatten

    if actual == expected
      if !expected.respond_to?(:deep_flatten)
        true
      else
        @failure_message = "expected #{actual.inspect} to not respond to #deep_flatten"
        false
      end
    else
      @failure_message = "expected #{subject.inspect} to flatten to #{expected.inspect}, but flattened to #{actual.inspect}"
      false
    end
  end

  failure_message do
    @failure_message
  end
end

describe DeepFlattening do
  def extended(object)
    object.extend(DeepFlattening)
    object
  end

  describe Array do
    context "when not extended" do
      subject { Array.new }
      it      { should_not respond_to(:deep_flatten) }
    end

    context "when extended" do
      subject { extended([]) }
      it      { should respond_to(:deep_flatten) }

      context "[]" do
        subject { extended([]) }
        it      { should flatten_to([]) }
      end

      context "[1,2,3]" do
        subject { extended([1,2,3]) }
        it      { should flatten_to([1,2,3]) }
      end

      context "[[1,2,3]]" do
        subject { extended([[1,2,3]]) }
        it      { should flatten_to([1,2,3]) }
      end

      context "[[1], [2], [3]]" do
        subject { extended([[1], [2], [3]]) }
        it      { should flatten_to([1,2,3]) }
      end

      context "[1, [2, [3, [4]]]]" do
        subject { extended([1, [2, [3, [4]]]]) }
        it      { should flatten_to([1,2,3,4]) }
      end
    end
  end

  describe Hash do
    context "when not extended" do
      subject { Hash.new }
      it      { should_not respond_to(:deep_flatten) }
    end

    context "when extended" do
      subject { extended(Hash.new) }
      it      { should respond_to(:deep_flatten) }

      context "{}" do
        subject { extended({}) }
        it      { should flatten_to([]) }
      end

      context "{:foo => :bar}" do
        subject { extended({:foo => :bar}) }
        it      { should flatten_to([:foo, :bar]) }
      end

      context "{:foo => {:bar => :baz}}" do
        subject { extended({:foo => {:bar => :baz}}) }
        it      { should flatten_to([:foo, :bar, :baz]) }
      end

      context "{:foo => {bar => {:baz => :qux}}}" do
        subject { extended({:foo => {:bar => {:baz => :qux}}}) }
        it      { should flatten_to([:foo, :bar, :baz, :qux]) }
      end
    end
  end

  describe "Mixed data structure" do
    context "when extended" do
      context "[1, {:foo => :bar}]" do
        subject { extended([1, {:foo => :bar}]) }
        it      { should flatten_to([1, :foo, :bar]) }
      end

      context "{:foo => [1,2]}" do
        subject { extended({:foo => [1,2]}) }
        it      { should flatten_to([:foo, 1, 2]) }
      end

      context "[1, {:foo => [2,3]}]" do
        subject { extended([1, {:foo => [2,3]}]) }
        it      { should flatten_to([1, :foo, 2, 3]) }
      end

      context "{:foo => {:bar => [1,2]}}" do
        subject { extended({:foo => {:bar => [1,2]}}) }
        it      { should flatten_to([:foo, :bar, 1, 2]) }
      end

      context "[1, {:foo => [2, {:bar => {:baz => [3,4]}}, 5]}]" do
        subject { extended([1, {:foo => [2, {:bar => {:baz => [3,4]}}, 5]}]) }
        it      { should flatten_to([1, :foo, 2, :bar, :baz, 3, 4, 5]) }
      end

      context "{:foo => {:bar => [1, {:baz => :qux}, 2]}}" do
        subject { extended({:foo => {:bar => [1, {:baz => :qux}, 2]}}) }
        it      { should flatten_to([:foo, :bar, 1, :baz, :qux, 2]) }
      end
    end
  end
end
