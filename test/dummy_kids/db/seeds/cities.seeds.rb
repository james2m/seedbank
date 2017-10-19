cities = %w(boonville oakland stateline reno ukiah)
counties = %w(mendocino alameda douglas washoe menodcino)

cities.each_with_index do |city, i|
  City.create(
    name: city,
    county_id: County.where(name: counties[i]).first
  )
end
