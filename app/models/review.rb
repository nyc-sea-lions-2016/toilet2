class Review < ActiveRecord::Base
	belongs_to :reviewer, class_name: 'User'
	belongs_to :toilet

  validates :review_text, :reviewer_id, :toilet, presence: true

  validate :unique_review

  def unique_review
    # Check to make sure user has not already reviewed that toilet.
  end
end
