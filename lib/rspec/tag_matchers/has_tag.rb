require 'nokogiri'

module RSpec::TagMatchers
  def have_tag(name)
    HasTag.new(name)
  end

  class HasTag
    def initialize(name)
      @name       = name.to_s
      @attributes = {}
      @criteria   = []
    end

    def matches?(rendered)
      Nokogiri::HTML::Document.parse(rendered).css(@name).select do |element|
        matches_attributes?(element) && matches_criteria?(element)
      end.length > 0
    end

    def with_attribute(attributes)
      @attributes.merge!(attributes)
      self
    end
    alias :with_attributes :with_attribute

    def with_criteria(method = nil, &block)
      @criteria << method   unless method.nil?
      @criteria << block    if block_given?
      self
    end

    private

    def matches_attributes?(element)
      @attributes.all? do |key, value|
        case value
        when String
          element[key] == value
        when Symbol
          element[key] =~ /^#{value}$/i
        when Regexp
          element[key] =~ value
        when true
          !element[key].nil?
        when false
          element[key].nil?
        end
      end
    end

    def matches_criteria?(element)
      @criteria.all? do |method|
        case method
        when Symbol
          send(method, element)
        when Proc
          method.call(element)
        end
      end
    end
  end
end
