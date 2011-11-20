require 'spec_helper'

describe RSpec::TagMatchers::HasTimeSelect do
  include RSpec::TagMatchers

  let(:start_time_hour)   { "<select name='event[start_time(4i)]'></select>" }
  let(:start_time_minute) { "<select name='event[start_time(5i)]'></select>" }
  let(:start_time_second) { "<select name='event[start_time(6i)]'></select>" }

  let(:end_time_hour)     { "<select name='event[end_time(4i)]'></select>" }
  let(:end_time_minute)   { "<select name='event[end_time(5i)]'></select>" }
  let(:end_time_second)   { "<select name='event[end_time(6i)]'></select>" }

  let(:start_time_with_hour_and_minute)        { start_time_hour + start_time_minute }
  let(:start_time_with_hour_minute_and_second) { start_time_hour + start_time_minute + start_time_second }

  let(:end_time_with_hour_and_minute)          { end_time_hour + end_time_minute }
  let(:end_time_with_hour_minute_and_second)   { end_time_hour + end_time_minute + end_time_second }

  describe "time select matching" do
    context "have_time_select" do
      subject { have_time_select }

      it      { should     match(start_time_with_hour_and_minute) }
      it      { should     match(start_time_with_hour_minute_and_second) }
      it      { should_not match(start_time_hour) }
      it      { should_not match(start_time_minute) }
      it      { should_not match(start_time_second) }

      it      { should     match(end_time_with_hour_and_minute) }
      it      { should     match(end_time_with_hour_minute_and_second) }
      it      { should_not match(end_time_hour) }
      it      { should_not match(end_time_minute) }
      it      { should_not match(end_time_second) }
    end
  end

  describe "matching input names" do
    context "have_time_select.for(:event => :start_time)" do
      subject { have_time_select.for(:event => :start_time) }

      it      { should     match(start_time_with_hour_and_minute) }
      it      { should     match(start_time_with_hour_minute_and_second) }

      it      { should_not match(end_time_with_hour_and_minute) }
      it      { should_not match(end_time_with_hour_minute_and_second) }
    end

    context "have_time_select.for(:event => :end_time)" do
      subject { have_time_select.for(:event => :end_time) }

      it      { should     match(end_time_with_hour_and_minute) }
      it      { should     match(end_time_with_hour_minute_and_second) }

      it      { should_not match(start_time_with_hour_and_minute) }
      it      { should_not match(start_time_with_hour_minute_and_second) }
    end
  end

  describe "#description" do
    context "for have_time_select" do
      subject { have_time_select.description }
      it      { should == "have time select" }
    end

    context "for have_time_select.for(:start_time)" do
      subject { have_time_select.for(:start_time).description }
      it      { should == "have time select for start_time" }
    end

    context "for have_time_select.for(:event => :start_time)" do
      subject { have_time_select.for(:event => :start_time).description }
      it      { should == "have time select for event.start_time" }
    end

    context "for have_time_select.for(:event, :start => :time)" do
      subject { have_time_select.for(:event, :start => :time).description }
      it      { should == "have time select for event.start.time" }
    end
  end

  describe "#failure_message" do
    context "for have_time_select" do
      let(:matcher) { have_time_select }

      context "matching '<bar></bar>'" do
        let(:document) { "<bar></bar>" }

        before  { matcher.matches?(document) }
        subject { matcher.failure_message }
        it      { should == "expected document to #{matcher.description}; got: #{document}" }
      end
    end
  end

  describe "#negative_failure_message" do
    context "for have_time_select" do
      let(:matcher) { have_time_select }

      context "matching \"<select name='(4i)'><select><select name='(5i)'></select>\"" do
        let(:document) { "<select name='(4i)'><select><select name='(5i)'></select>" }

        before  { matcher.matches?(document) }
        subject { matcher.negative_failure_message }
        it      { should == "expected document to not #{matcher.description}; got: #{document}" }
      end
    end
  end
end
