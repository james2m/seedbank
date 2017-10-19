states = %w(california nevada)
states.each do |state|
  State.create( name: state )
end
