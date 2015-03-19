require 'spec_helper'

describe "SerialSpec::RequestResponse::ProvideMatcher" do
  include SerialSpec::RequestResponse::ProvideMatcher

  let(:comments) do 
    [Comment.new(:title => "Comment1"), Comment.new(:title => "Comment2")]
  end
  let(:user) { User.new(name: "Enrique") }
  let(:serialized_post) do
    PostSerializer.new(post).as_json
  end
  let(:serialized_posts) do
    PostSerializer.new([post]).as_json
  end


  context "using provide" do
    let(:post) do
      Post.new(:title => "New Post", :body => "Body of new post")
    end
    context ":as not valid" do
      it "should raise error" do
        expect{provide(post, as: Object) == serialized_post}.to \
          raise_error(SerialSpec::RequestResponse::ProvideMatcher::Provide::SerializerNotFound)
      end
    end
    context "with no associations" do
      context "supplying :as serializer" do
        it "should match serialized model" do
          expect(serialized_post).to provide(post, as: PostSerializer)
        end
        it "should fall back to default serializer" do
          expect(serialized_post).to provide(post)
        end
      end
    end
    context "with associations" do
      let(:post) do 
        p = Post.new(:title => "New Post", :body => "Body of new post")
        p.comments = comments
        p.author = user
        p
      end
        it "should match serialized model" do
require'pry';binding.pry
          expect(serialized_post).to provide(post, as: PostSerializer)
        end
        it "should fall back to default serializer" do
          expect(serialized_post).to provide(post)
        end

    end
  end

end

