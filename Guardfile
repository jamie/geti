guard 'rspec', :all_after_pass => false, :all_on_start => false do
  watch(%r{^spec/.+_spec\.rb$})
  watch(%r{^lib/(.+)\.rb$})     { |m| "spec/#{m[1].gsub('/','_')}_spec.rb" }
end
