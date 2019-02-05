class Comment < ApplicationRecord
  belongs_to :user_comment, class_name: 'Comment', foreign_key: 'parent_comment_id', optional: true
  has_many :replies, class_name: 'Comment', foreign_key: 'parent_comment_id'
  belongs_to :cards

  enum comment_type: [:reply, :comment]

  before_create :set_comment_type

  def set_comment_type
    comment_type =  if self.parent_comment_id.present?
                      Comment.comment_types["reply"]
                    else
                      Comment.comment_types["comment"]
                    end
  end

end
