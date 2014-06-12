FakeModel.seed 'with_inline_memo'
let(:inline_let) { FakeModel.calling_let 'INLINE_LET' }
let!(:inline_let!) { FakeModel.calling_let! 'INLINE_LET!' }
