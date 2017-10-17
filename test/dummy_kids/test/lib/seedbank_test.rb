require 'test_helper'
require 'seedbank'
require 'rake'

describe 'DummyKids' do
  subject { 'db:seed:users' }

  it 'generates the awesomeness report' do
    Rails.application.load_tasks
    Rake::Task[subject].invoke
    assert User.where(name: "fred").size.must_equal 1
  end
end
