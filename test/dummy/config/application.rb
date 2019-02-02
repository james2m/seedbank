# frozen_string_literal: true
require File.expand_path('boot', __dir__)

Bundler.require(:default, Rails.env)

module Dummy
  class Application < Rails::Application
  end
end
