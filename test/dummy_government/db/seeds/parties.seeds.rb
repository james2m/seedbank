parties = %w(republican democrat)
parties.each do |party|
  Party.create( affiliation: party )
end
