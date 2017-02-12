# frozen_string_literal: true
after :dependency, :dependency2 do
  FakeModel.seed('dependent on several')
end
