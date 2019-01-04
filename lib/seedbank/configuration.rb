# frozen_string_literal: true

module Seedbank
  module Configuration
    # Start a Seedbank configuration block in an initializer.
    #
    # example: Provide before and after lambdas
    #   Seedbank.configure do |config|
    #     config.before = lambda do
    #       ...
    #     end
    #   end
    def configure
      yield self
    end

    mattr_accessor :before_each
    @before_each = nil

    mattr_accessor :after_each
    @after_each = nil
  end
end
