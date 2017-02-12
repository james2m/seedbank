# frozen_string_literal: true
after :dependent, :dependency2 do
  FakeModel.seed('dependent on nested')
end
