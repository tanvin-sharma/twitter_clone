class TweetSerializer < ActiveModel::Serializer
  attributes :id, :content, :no_of_likes, :created_at

  has_one :author, serializer: UserSerializer
  has_many :comments, serializer: CommentSerializer

  def author
    object.user
  end

  def created_at
    object.created_at.to_i
  end

  def updated_at
    object.updated_at.to_i
  end
end