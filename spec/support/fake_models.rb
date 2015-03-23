require 'active_model_serializers' 

# inspired from ASM
class Model
include ActiveModel::SerializerSupport
include ActiveModel::ArraySerializerSupport

  attr_reader :options
  def initialize(attr=[],options={})
    @attributes = attr
    @options = options
  end

end

class Comment < Model
  attr_accessor :title
  def initialize(attrs)
    self.title = attrs[:title]
  end
  def active_model_serializer; CommentSerializer; end
end

class Post < Model
  attr_accessor :comments, :comments_disabled, :author, :title, :body
  def initialize(attributes)
    self.comments ||= attributes[:comments] || [] 
    self.author = attributes[:author] || nil
    self.title = attributes[:title] || nil
    self.body  = attributes[:body] || nil
  end
  def active_model_serializer; PostSerializer; end
end

class User < Model
  attr_accessor :name
  def initialize(attrs)
    self.name = attrs[:name]
  end
  def active_model_serializer; CommentSerializer; end
end


# SErializers

class CommentSerializer < ActiveModel::Serializer
  attributes :title
end

class UserSerializer < ActiveModel::Serializer
  attributes :name
end

class PostSerializer < ActiveModel::Serializer
  attributes :title, :body
  has_many :comments, :serializer => CommentSerializer
  has_one :author, :serializer => UserSerializer
end



