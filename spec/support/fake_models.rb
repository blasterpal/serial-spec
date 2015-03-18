# inspired from ASM
class Model
  def initialize(hash={})
    @attributes = hash
  end

  def read_attribute_for_serialization(name)
    @attributes[name]
  end

  def as_json(*)
    { :model => "Model" }
  end
end

class Post < Model
  def active_model_serializer; PostSerializer; end
end

class PostSerializer < ActiveModel::Serializer
  attributes :title, :body
  has_many :comments, :serializer => CommentSerializer
end

class Comment < Model
    def active_model_serializer; CommentSerializer; end
end

