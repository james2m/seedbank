# frozen_string_literal: true
after :dependency do
  FakeModel.seed('dependent')
end
