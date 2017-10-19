after :states do
  counties = %w(mendocino alameda douglas washoe menodocino)
  states = %w(california california nevada nevada california)

  counties.each_with_index do |county, i|
    County.create(
      name: county,
      state_id: State.where(name: states[i]).first
    )
  end
end
