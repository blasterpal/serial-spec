require 'active_support/inflector'

module SerialSpec
  module RequestResponse
    module ProvideMatcher

      def provide(serializable,options={})
        SerialSpec::RequestResponse::ProvideMatcher::Provide.new(serializable, options)
      end

      class Provide
        class SerializerNotFound < StandardError ; end

        attr_reader :as_serializer
        attr_reader :expected 

        def initialize(expected,options={})
          @expected = expected
          @as_serializer = options[:as]
        end


          def expected_serialized
            if as_serializer
              unless as_serializer.respond_to?(:as_json)
                throw(:failed, :serializer_not_valid)
              end
              as_serializer.new(expected).as_json
            else
              ActiveModel::Serializer.new(expected).as_json
            end
          end

          def matches?(actual)
            failure = catch(:failed) do
              # make a deep hash comparison here
              expected_serialized == actual_to_hash(actual)
              @failure_message = failed_message(failure) if failure 
              !failure
            end
          end

          def actual_to_hash(actual)
            if actual.kind_of? SerialSpec::ParsedBody 
              actual
              #actual.execute
            else
              actual 
            end
          end
          
          # order of keys and key types
          def deep_match?(actual_hash,expected_hash)

          end


        # when rspec asserts eq
        alias == matches?

        def failed_message(msg)
          case msg
          when :serializer_not_valid    then "as: serializer not valid"
          else
            raise "[ERROR] need a better catch statement"
          end
        end

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
