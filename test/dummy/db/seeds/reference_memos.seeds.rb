# frozen_string_literal: true
after('with_block_memo') do
  block_let
  inline_let
  inline_method
end
