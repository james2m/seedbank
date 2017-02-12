# frozen_string_literal: true
def inline_method
  FakeModel.calling_method 'inline_method'
end

FakeModel.seed 'with_inline_memo'
let(:inline_let) { FakeModel.calling_let 'INLINE_LET' }
let!(:inline_let!) { FakeModel.calling_let! 'INLINE_LET!' }
