require 'spec_helper'

describe "SerialSpec::RequestResponse::Provide" do
  include SerialSpec::RequestResponse::Provide

  ## Q:
  ## 1.does matcher needs to be aware of type being matched again? i.e. expects argument of "body"
  let(:post) { Post.new }
  let(:comments) do 
    [Comment.new(:title => "Comment1"), Comment.new(:title => "Comment2")]
  end

  let(:resource_serializer)  do
    resource.as_json
  end
  let(:response) do 
    SerialSpec::ParsedBody.new(resource.to_json)
  end

  context ".provide" do
    context "resource supplied" do

      it "should match serializable object" do
        provide(resource).to eq(true)
      end
    end
    context "enumerable supplied" do

    end
  end
end

