class List < ApplicationRecord
  belongs_to :owner, :class_name => 'User', :foreign_key => 'created_by'
  has_many :list_users, dependent: :destroy
  has_many :users, through: :list_users
  has_many :cards, dependent: :destroy
  validates :title, presence: true

  #return cards with order of comments count
  def get_cards
    cards.select('cards.*')
         .joins('LEFT JOIN comments ON comments.card_id = cards.id and comments.comment_type = 1')
         .group('cards.id')
         .order('count(comments.id) desc')
  end
end

