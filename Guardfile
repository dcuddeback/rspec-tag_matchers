# vim: filetype=ruby

guard 'bundler' do
  watch('Gemfile')
end

guard 'rspec', :version => 2, :all_on_start => true, :all_after_pass => true do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})       { |m| "spec/lib/#{m[1]}_spec.rb" }
  watch(%r{^core_ext/(.+)\.rb$})  { |m| "spec/core_ext/#{m[1]}_spec.rb" }
  watch("spec/spec_helper.rb")    { "spec" }
end
