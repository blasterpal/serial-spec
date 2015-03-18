module SerialSpec
  module RequestResponse
    module Provide

      def provide(*expected_keys)
        SerialSpec::RequestResponse::Provide.new(*expected_keys)
      end
    end
  end
end
