require 'spec_helper'

describe RSpec::TagMatchers::HasDateSelect do
  include RSpec::TagMatchers

  # single inputs for start_date
  let(:start_date_year)         { "<select name='event[start_date(1i)]'></select>" }
  let(:start_date_month)        { "<select name='event[start_date(2i)]'></select>" }
  let(:start_date_day)          { "<select name='event[start_date(3i)]'></select>" }

  # single inputs for end_date
  let(:end_date_year)           { "<select name='event[end_date(1i)]'></select>" }
  let(:end_date_month)          { "<select name='event[end_date(2i)]'></select>" }
  let(:end_date_day)            { "<select name='event[end_date(3i)]'></select>" }

  # hidden inputs
  let(:hidden_start_date_year)  { "<input type='hidden' name='event[start_date(1i)]' />" }
  let(:hidden_start_date_month) { "<input type='hidden' name='event[start_date(2i)]' />" }
  let(:hidden_start_date_day)   { "<input type='hidden' name='event[start_date(3i)]' />" }
  let(:hidden_other)            { "<input type='hidden' name='foo' />" }

  # combined inputs for start_date
  let(:start_date_with_year_month_and_day) { start_date_year + start_date_month + start_date_day }
  let(:start_date_with_year_and_month)     { start_date_year + start_date_month }

  # combined inputs for end_date
  let(:end_date_with_year_and_month)       { end_date_year + end_date_month }
  let(:end_date_with_year_month_and_day)   { end_date_year + end_date_month + end_date_day }

  # combined inputs for start_date with hidden inputs
  let(:start_date_with_year_and_month_and_hidden_other)      { start_date_year + start_date_month + hidden_other }
  let(:start_date_with_year_and_month_and_hidden_day)        { start_date_year + start_date_month + hidden_start_date_day }
  let(:start_date_with_year_and_hidden_month_and_day)        { start_date_year + hidden_start_date_month + start_date_day }
  let(:start_date_with_hidden_year_and_month_and_day)        { hidden_start_date_year + start_date_month + start_date_day }
  let(:start_date_with_year_and_hidden_month_and_hidden_day) { start_date_year + hidden_start_date_month + hidden_start_date_day }

  describe "date select matching" do
    context "have_date_select" do
      subject { have_date_select }

      it      { should     match(start_date_with_year_month_and_day) }
      it      { should_not match(start_date_with_year_and_month) }
      it      { should_not match(start_date_year) }
      it      { should_not match(start_date_month) }
      it      { should_not match(start_date_day) }

      it      { should     match(end_date_with_year_month_and_day) }
      it      { should_not match(end_date_with_year_and_month) }
      it      { should_not match(end_date_year) }
      it      { should_not match(end_date_month) }
      it      { should_not match(end_date_day) }
    end
  end

  describe "matching discarded date parts" do
    context "have_date_select.discard(:day)" do
      subject { have_date_select.discard(:day) }

      it      { should     match(start_date_with_year_and_month_and_hidden_day) }
      it      { should_not match(start_date_with_year_and_month_and_hidden_other) }
      it      { should_not match(start_date_with_year_month_and_day) }
      it      { should_not match(start_date_with_year_and_month) }
    end

    context "have_date_select.discard(:month)" do
      subject { have_date_select.discard(:month) }

      it      { should     match(start_date_with_year_and_hidden_month_and_day) }
      it      { should_not match(start_date_with_year_month_and_day) }
    end

    context "have_date_select.discard(:year)" do
      subject { have_date_select.discard(:year) }

      it      { should     match(start_date_with_hidden_year_and_month_and_day) }
      it      { should_not match(start_date_with_year_month_and_day) }
    end

    context "have_date_select.discard(:month, :day)" do
      subject { have_date_select.discard(:month, :day) }

      it      { should     match(start_date_with_year_and_hidden_month_and_hidden_day) }
      it      { should_not match(start_date_with_year_month_and_day) }
    end
  end

  describe "matching input names" do
    context "have_date_select.for(:event => :start_date)" do
      subject { have_date_select.for(:event => :start_date) }

      it      { should     match(start_date_with_year_month_and_day) }
      it      { should_not match(start_date_with_year_and_month) }

      it      { should_not match(end_date_with_year_and_month) }
      it      { should_not match(end_date_with_year_month_and_day) }
    end

    context "have_date_select.for(:event => :end_date)" do
      subject { have_date_select.for(:event => :end_date) }

      it      { should     match(end_date_with_year_month_and_day) }
      it      { should_not match(end_date_with_year_and_month) }

      it      { should_not match(start_date_with_year_and_month) }
      it      { should_not match(start_date_with_year_month_and_day) }
    end
  end

end
