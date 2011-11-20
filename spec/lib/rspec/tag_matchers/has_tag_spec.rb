require 'spec_helper'

describe RSpec::TagMatchers::HasTag do
  include RSpec::TagMatchers

  describe "inputs" do
    let(:string)   { "<foo></foo>" }
    let(:document) { Nokogiri::HTML::Document.parse(string) }
    let(:node_set) { document.css("foo") }

    subject { have_tag(:foo) }

    it "should match against String" do
      subject.should match(string)
    end

    it "should match against Nokogiri::XML::NodeSet" do
      subject.should match(node_set)
    end
  end

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
        it      { should     match("<foo bar></foo>") }
        it      { should_not match("<foo qux='baz'></foo>") }
        it      { should_not match("<foo>bar</foo>") }
        it      { should_not match("<foo></foo><qux bar='baz'></qux>") }
      end

      context 'have_tag(:foo).with_attribute(:qux => true)' do
        subject { have_tag(:foo).with_attribute(:qux => true) }
        it      { should_not match("<foo></foo>") }
        it      { should_not match("<foo bar='baz'></foo>") }
        it      { should     match("<foo qux='baz'></foo>") }
        it      { should     match("<foo qux></foo>") }
        it      { should_not match("<foo></foo><qux bar='baz'></qux>") }
      end
    end

    context "false matches absence of attribute" do
      context 'have_tag(:foo).with_attribute(:bar => false)' do
        subject { have_tag(:foo).with_attribute(:bar => false) }
        it      { should     match("<foo></foo>") }
        it      { should_not match("<foo bar='baz'></foo>") }
        it      { should_not match("<foo bar='qux'></foo>") }
        it      { should_not match("<foo bar></foo>") }
        it      { should     match("<foo qux='baz'></foo>") }
      end

      context 'have_tag(:foo).with_attribute(:qux => false)' do
        subject { have_tag(:foo).with_attribute(:qux => false) }
        it      { should     match("<foo></foo>") }
        it      { should     match("<foo bar='baz'></foo>") }
        it      { should_not match("<foo qux='baz'></foo>") }
        it      { should_not match("<foo qux></foo>") }
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
        it      { should     match("<foo bar='1' baz='2'></foo>") }
        it      { should_not match("<foo bar='1'></foo>") }
        it      { should_not match("<foo baz='2'></foo>") }
        it      { should_not match("<foo></foo>") }
      end
    end
  end

  describe "extra criteria" do
    context "as symbol" do
      context "have_tag(:foo).with_criteria(:custom_filter)" do
        subject { have_tag(:foo).with_criteria(:custom_filter) }

        it "should call custom_filter with Nokogiri::XML::Element as argument" do
          RSpec::TagMatchers::HasTag.any_instance.should_receive(:custom_filter).with(an_instance_of(Nokogiri::XML::Element))
          subject.matches?("<foo></foo>")
        end

        context "when custom_filter returns true" do
          before { RSpec::TagMatchers::HasTag.any_instance.stub(:custom_filter) { true } }
          it     { should     match("<foo></foo>") }
          it     { should_not match("<bar></bar>") }
        end

        context "when custom_filter returns false" do
          before { RSpec::TagMatchers::HasTag.any_instance.stub(:custom_filter) { false } }
          it     { should_not match("<foo></foo>") }
          it     { should_not match("<bar></bar>") }
        end
      end
    end

    context "as block" do
      context "have_tag(:foo).with_criteria { |element| ... }" do
        let!(:block) { lambda { |element| true } }
        subject      { have_tag(:foo).with_criteria { |element| block.call(element) } }

        it "should call the block with Nokogiri::XML::Element as argument" do
          block.should_receive(:call).with(an_instance_of(Nokogiri::XML::Element))
          subject.matches?("<foo></foo>")
        end

        context "when block returns true" do
          before { block.stub(:call) { true } }
          it     { should     match("<foo></foo>") }
          it     { should_not match("<bar></bar>") }
        end

        context "when block returns false" do
          before { block.stub(:call) { false } }
          it     { should_not match("<foo></foo>") }
          it     { should_not match("<bar></bar>") }
        end
      end
    end

    context "multiple criteria" do
      context "have_tag(:foo).with_criteria(:filter_1).with_criteria(:filter_2)" do
        subject { have_tag(:foo).with_criteria(:filter_1).with_criteria(:filter_2) }

        context "both filters return true" do
          before do
            RSpec::TagMatchers::HasTag.any_instance.stub(:filter_1) { true }
            RSpec::TagMatchers::HasTag.any_instance.stub(:filter_2) { true }
          end

          it { should     match("<foo></foo>") }
          it { should_not match("<bar></bar>") }
        end

        context "filter_1 returns false" do
          before do
            RSpec::TagMatchers::HasTag.any_instance.stub(:filter_1) { false }
            RSpec::TagMatchers::HasTag.any_instance.stub(:filter_2) { true }
          end

          it { should_not match("<foo></foo>") }
          it { should_not match("<bar></bar>") }
        end

        context "filter_2 returns false" do
          before do
            RSpec::TagMatchers::HasTag.any_instance.stub(:filter_1) { true }
            RSpec::TagMatchers::HasTag.any_instance.stub(:filter_2) { false }
          end

          it { should_not match("<foo></foo>") }
          it { should_not match("<bar></bar>") }
        end

        context "both filters return false" do
          before do
            RSpec::TagMatchers::HasTag.any_instance.stub(:filter_1) { false }
            RSpec::TagMatchers::HasTag.any_instance.stub(:filter_2) { false }
          end

          it { should_not match("<foo></foo>") }
          it { should_not match("<bar></bar>") }
        end
      end
    end
  end

  describe "#description" do
    context "for simple matchers" do
      context "have_tag(:foo)" do
        subject { have_tag(:foo) }
        its(:description) { should == 'have "foo" tag' }
      end

      context "have_tag(:bar)" do
        subject { have_tag(:bar) }
        its(:description) { should == 'have "bar" tag' }
      end
    end

    context "for matchers with attribute criteria" do
      context "have_tag(:foo).with_attribute(:bar => :baz)" do
        subject { have_tag(:foo).with_attribute(:bar => :baz) }
        its(:description) { should == 'have "foo" tag with attribute bar=:baz' }
      end

      context "have_tag(:foo).with_attribute(:bar => 'baz')" do
        subject { have_tag(:foo).with_attribute(:bar => 'baz') }
        its(:description) { should == 'have "foo" tag with attribute bar="baz"' }
      end

      context "have_tag(:foo).with_attribute(:bar => /baz/)" do
        subject { have_tag(:foo).with_attribute(:bar => /baz/) }
        its(:description) { should == 'have "foo" tag with attribute bar=~/baz/' }
      end

      context "have_tag(:foo).with_attribute(:bar => true)" do
        subject { have_tag(:foo).with_attribute(:bar => true) }
        its(:description) { should == 'have "foo" tag with attribute bar=anything' }
      end

      context "have_tag(:foo).with_attribute(:bar => false)" do
        subject { have_tag(:foo).with_attribute(:bar => false) }
        its(:description) { should == 'have "foo" tag without attribute bar' }
      end

      context "have_tag(:foo).with_attributes(:bar => '1', :baz => '2')" do
        subject { have_tag(:foo).with_attributes(:bar => '1', :baz => '2') }
        its(:description) { should == 'have "foo" tag with attributes bar="1" and baz="2"' }
      end

      context "have_tag(:foo).with_attributes(:bar => '1', :baz => '2', :qux => '3')" do
        subject { have_tag(:foo).with_attributes(:bar => '1', :baz => '2', :qux => '3') }
        its(:description) { should == 'have "foo" tag with attributes bar="1", baz="2", and qux="3"' }
      end

      context "have_tag(:foo).with_attributes(:bar => true, :baz => false)" do
        subject { have_tag(:foo).with_attributes(:bar => true, :baz => false) }
        its(:description) { should == 'have "foo" tag with attribute bar=anything and without attribute baz' }
      end
    end
  end
end
