require 'nokogiri'

module RSpec::TagMatchers
  def have_tag(name)
    HasTag.new(name)
  end

  class HasTag
    def initialize(name)
      @name       = name.to_s
      @attributes = {}
    end

    def matches?(rendered)
      Nokogiri::HTML::Document.parse(rendered).css(@name).select do |element|
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
      end.length > 0
    end

    def with_attribute(attributes)
      @attributes.merge!(attributes)
      self
    end
    alias :with_attributes :with_attribute
  end
end
