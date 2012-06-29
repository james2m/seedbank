after :dependency, :dependency2 do
  FakeModel.seed('dependent on several')
end