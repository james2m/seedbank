counties = [
  { name: "mendocino", party: "democrat", state: "california" },
  { name: "douglas", party: "republican", state: "nevada"}
]
counties.each do |county|
  County.create(
    name: county[:name],
    state: State.where(name: county[:state]).first,
    party: Party.where(affiliation: county[:party]).first 
  )
end
