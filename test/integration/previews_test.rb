require 'integration_test_helper'

class PreviewsTest < ActionDispatch::IntegrationTest

  def setup_users
    @author ||= User.create(:name=>"Author",:email=>"test@example.com")
    @reviewer ||= User.create(:name=>"Reviewer",:email=>"test@example.com")
  end

  def setup_place_thing(random_name)
    setup_users

    @place = @author.create_publication(:place, :name => random_name, :slug => 'test-place')
    @place.editions.first.title = random_name
    @place.editions.first.introduction = 'Body text'
    @place.editions.first.more_information = 'More body text'
    @place.editions.first.place_type = 'registry-offices'
    @place.save

    return @place
  end

  def publish_answer(random_name)
    setup_users

    @answer = @author.create_publication(:answer, :name => random_name, :slug => 'test-answer', :panopticon_id => 15328)
    @answer.editions.first.title = random_name
    @answer.editions.first.body = 'Body text'
    @answer.save!

    @author.request_review(@answer.editions.first, {comment: ''})
    @reviewer.okay(@answer.editions.first, {comment: ''})
    @author.publish(@answer.editions.first, {comment: 'Done'})
    @answer.calculate_statuses
    @answer.save!

    return @answer
  end
end
