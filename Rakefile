require 'rake/testtask'

Rake.add_rakelib 'lib/tasks'

task default: %w[test]

Rake::TestTask.new do |t|
  t.libs << 'test'
  t.test_files = FileList['src/tests/*test.rb']
end
