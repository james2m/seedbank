# .simplecov
# frozen_string_literal: true

SimpleCov.configure do
  enable_coverage :branch
  skip '/test/'

  coverage_dir ENV.fetch('COVERAGE_DIR', 'coverage')
  minimum_coverage line: 90, branch: 70
end
