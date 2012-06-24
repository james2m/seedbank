after [:prereq, :cocker] do
  puts 'running: test'
  puts self.methods - Kernel.methods
end