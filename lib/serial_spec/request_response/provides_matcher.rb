require 'active_support/inflector'
require 'yaml'

module SerialSpec
  module RequestResponse
    module ProvideMatcher

      def provide(expected,options={})
        SerialSpec::RequestResponse::ProvideMatcher::Provide.new(expected, options)
      end

      class Provide
        class SerializerNotFound < StandardError ; end

        attr_reader :as_serializer
        attr_reader :expected

        def initialize(expected,options={})
          @expected = expected
          @as_serializer = options[:as]
        end

        def actual_to_hash(actual)
          if actual.kind_of? SerialSpec::ParsedBody 
            actual.execute
          else
            actual
          end
        end

        def expected_to_hash
          return_hash = {}
          if as_serializer && serializer = as_serializer.new(expected)
            unless serializer.respond_to?(:as_json)
              throw(:failed, :serializer_not_valid)
            end
            serializer.as_json
          else
            ActiveModel::Serializer.new(expected).as_json
          end
        end

        #lazy recursive comparison
        def deep_match?(actual,expected_hash)
          unless actual.kind_of?(Hash)
            throw(:failed, :response_not_valid)
          end
          if actual.deep_stringify_keys.to_yaml.eql?(expected_hash.deep_stringify_keys.to_yaml)
          else
            throw(:failed, :response_and_model_dont_match)
          end
        end

        def matches?(actual)
          failure = catch(:failed) do
            deep_match?(actual_to_hash(actual),expected_to_hash) 
          end
          @failure_message = failed_message(failure) if failure 
          !failure
        end

        # when rspec asserts eq
        alias == matches?

        def failed_message(msg) 
          case msg
          when :response_and_model_dont_match
            "response and serialized object do not match" 
          when :serializer_not_valid
            "serializer not valid"
          when :response_not_valid
            "response not valid or hash"
          else
            "no failed_message found, this is default"
          end
        end

        def failure_message
          @failure_message || "error should TO  implement"
        end

        def failure_message_when_negated
          @failure_message || "error should not  TO implement"
        end

      end

    end
  end
end
