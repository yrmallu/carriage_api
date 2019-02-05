class Card < ApplicationRecord
  belongs_to :list
  belongs_to :owner, :class_name => 'User', :foreign_key => 'created_by'
  has_many :comments

  # returns lastest 3 comment for the card
  def get_cards
    card_hash = self.as_json
    card_hash[:comments] = comments.comment.order(created_at: :desc).limit(3)
  end

end
