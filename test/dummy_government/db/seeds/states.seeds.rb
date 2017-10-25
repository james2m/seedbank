states = [
  { name: "california", party: "democrat" },
  { name: "nevada", party: "republican"}
]
states.each do |state|
  State.create(
    name: state[:name],
    party: Party.where(affiliation: state[:party]).first )
end
