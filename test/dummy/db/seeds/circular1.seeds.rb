# frozen_string_literal: true
after :circular2 do
  FakeModel.seed('circular1')
end
