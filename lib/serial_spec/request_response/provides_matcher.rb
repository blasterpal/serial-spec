require 'active_support/inflector'

module SerialSpec
  module RequestResponse
    module ProvideMatcher

      def provide(serializable,options={})
        SerialSpec::RequestResponse::ProvideMatcher::Provide.new(serializable, options)
      end

      class Provide

        attr_reader :as_serializer
        attr_reader :expected 

        def initialize(expected,options={})
          @expected = expected 
          @as_serializer = options[:as].to_s.safe_constantize
        end

        def expected_serialized
          if as_serializer
            as_serializer.new(expected).as_json
          else
            expected.to_json
          end
        end

        def matches?(actual)
         expected_serialized == actual_to_hash(actual)
        end

        def actual_to_hash(actual)
          if actual.kind_of? SerialSpec::ParsedBody 
            actual.execute
          else
            actual 
          end
        end

        # when rspec asserts eq
        alias == matches?

        def failure_message
          "error should to implement"
        end

        def failure_message_when_negated
          "error should not to implement"
        end

      end

    end
  end
end
