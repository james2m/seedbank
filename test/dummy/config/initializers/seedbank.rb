# frozen_string_literal: true

require 'seedbank'

Seedbank.configure do |config|
  config.before_each = lambda do
    BeforeEachCalls << '.'
  end

  config.after_each = lambda do
    AfterEachCalls << '.'
  end
end
