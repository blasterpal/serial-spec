require 'active_model_serializers' 

# inspired from ASM
class Model
  
  attr_reader :options
  def initialize(hash={},options={})
    @attributes = hash
    @options = options
  end

  def read_attribute_for_serialization(name)
    @attributes[name]
  end

  def serializable_hash
    @attributes
  end

  def as_json(options=nil)
    options ||= {}
    if options[:root] == false
      serializable_hash
    else
      { self.class.to_s.downcase.to_sym => serializable_hash }
    end
  end

end

class Comment < Model
  def active_model_serializer; CommentSerializer; end
end

class Post < Model
  attr_accessor :comments, :comments_disabled, :author
  def initialize(attributes)
    super(attributes)
    self.comments ||= []
    self.author = nil
  end
  def active_model_serializer; PostSerializer; end
end

class User < Model
  def active_model_serializer; CommentSerializer; end
end


# SErializers

class CommentSerializer
  def initialize(comment, options={})
    @object = comment
  end

  attr_reader :object

  def serializable_hash
    { :title => @object.read_attribute_for_serialization(:title) }
  end

  def as_json(options=nil)
    options ||= {}
    if options[:root] == false
      serializable_hash
    else
      { :comment => serializable_hash }
    end
  end
end

class UserSerializer < ActiveModel::Serializer
  attributes :name
end

class PostSerializer < ActiveModel::Serializer
  attributes :title, :body
  has_many :comments, :serializer => CommentSerializer
  has_one :author, :serializer => UserSerializer
end



