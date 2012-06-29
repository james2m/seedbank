after :dependency do
  FakeModel.seed('dependent')
end