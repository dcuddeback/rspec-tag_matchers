$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', '..', 'core_ext'))

module RSpec
  module TagMatchers
  end
end

require 'rspec/tag_matchers/has_tag'
require 'rspec/tag_matchers/has_form'
require 'rspec/tag_matchers/has_input'
require 'rspec/tag_matchers/has_checkbox'
require 'rspec/tag_matchers/has_select'
require 'rspec/tag_matchers/has_time_select'
