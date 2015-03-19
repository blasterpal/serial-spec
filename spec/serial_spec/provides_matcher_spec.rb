require 'spec_helper'

describe "SerialSpec::RequestResponse::ProvideMatcher" do
  include SerialSpec::RequestResponse::ProvideMatcher

  let(:comments) do 
    [Comment.new(:title => "Comment1"), Comment.new(:title => "Comment2")]
  end
  let(:user) { User.new(name: "Enrique") }
  #let(:post) do 
    #p = Post.new(:title => "New Post", :body => "Body of new post")
    #p.comments = comments
    #p.author = user
    #p
  #end
  let(:serialized_post) do
    PostSerializer.new(post).as_json
  end


  context "using provide" do
    context "no associations" do
      let(:post) do
        Post.new(:title => "New Post", :body => "Body of new post")
      end
      context "with :as" do
        it "should match serialized model" do
          expect(serialized_post).to provide(post, as: PostSerializer)
        end
        xit "should fall back to default serializer" do
          expect(serialized_post).to provide(post, as: nil)
        end
      end
    end
  end

end

