cities = [
  { name: "boonville", party: "democrat", county: "mendocino" },
  { name: "stateline", party: "republican", county: "douglas"}
]
cities.each do |city|
  City.create(
    name: city[:name],
    county: County.where(name: city[:county]).first,
    party: Party.where(affiliation: city[:party]).first
  )
end
