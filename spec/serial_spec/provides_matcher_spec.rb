require 'spec_helper'

describe "SerialSpec::RequestResponse::ProvideMatcher" do
  include SerialSpec::RequestResponse::ProvideMatcher
  let(:post) do
    Post.new(:title => "New Post", :body => "Body of new post")
  end
  let(:posts) do 
    [
    Post.new(:title => "New Post", :body => "Body of new post"),
    Post.new(:title => "New Post2", :body => "Body of new post2")
    ]
  end
  let(:comments) do 
    [Comment.new(:title => "Comment1"), Comment.new(:title => "Comment2")]
  end
  let(:reordered_comments) do 
    comments.reverse
  end
  let(:user) { User.new(name: "Enrique") }

  let(:serialized_post) do
    PostSerializer.new(post).as_json
  end
  let(:serialized_posts) do
    PostSerializer.new([post]).as_json
  end

  let(:resource_json) { PostSerializer.new(post).as_json.to_json }
  let(:collection_json) { Activemodel::ArraySerializer.new(posts,serializer: PostSerializer, root: 'posts')}

  let(:response) { resource_json }
  let(:parsed_body) { SerialSpec::ParsedBody.new(response) }
  let(:execute_hash) { SerialSpec::ParsedBody.new(response).execute }

  context "using provide" do

    context ":as not valid" do
      xit "should return rspec error" do
        expect(parsed_body).to provide(post, as: String)
      end
    end

    context "when actual is ParsedBody" do
      it "should match" do
        expect(parsed_body).to provide(post, as: PostSerializer)
      end
    end
    context "when actual is Hash" do
      it "should match" do
        expect(parsed_body.execute).to provide(post, as: PostSerializer)
      end
    end

    context "resource" do
      it "should match serialized resource" do
        expect(parsed_body).to provide(post, as: PostSerializer)
      end
    end
    context "collection" do
      let(:response) { collection_json }
      it "should match serialized resource" do
        expect(parsed_body).to provide(post, as: PostSerializer)
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
      let(:other_post) do 
        p = post
        p.comments = reordered_comments
        p.author = user
        p
      end

      it "should match serialized model" do
        expect(serialized_post).to provide(post, as: PostSerializer)
      end
      it "should fall back to default serializer" do
        expect(serialized_post).to provide(post)
      end
      context "ordering" do
        let(:serialized_post) do
          PostSerializer.new(other_post).as_json
        end
        it "should match serialized model" do
          expect(serialized_post).to provide(post, as: PostSerializer)
        end
      end

    end
  end

end

