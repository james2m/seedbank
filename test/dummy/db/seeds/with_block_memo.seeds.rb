# frozen_string_literal: true
after('with_inline_memo') do
  FakeModel.seed 'with_block_memo'
  let(:block_let) { FakeModel.calling_let 'BLOCK_LET' }
  let!(:block_let!) { FakeModel.calling_let! 'BLOCK_LET!' }
end
