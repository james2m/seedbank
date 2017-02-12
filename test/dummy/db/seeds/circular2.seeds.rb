# frozen_string_literal: true
after :circular1 do
  FakeModel.seed('circular2')
end
