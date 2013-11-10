require 'webmachine'
require 'json'

require 'pact_broker/services'
require 'pact_broker/resources/json_resource'

require 'pact_broker/api/representors/representable_pact'

module PactBroker

  module Resources

    class LatestPacts < Webmachine::Resource

      include PactBroker::Services

      #FIX to hal+json
      def content_types_provided
        [["application/hal+json", :to_json]]
      end

      def allowed_methods
        ["GET"]
      end

      def to_json
        generate_json(pact_service.find_latest_pacts)
      end

      def generate_json pacts
        pacts = pacts.collect{ | pact | create_representable_pact(pact) }
        pacts.extend(PactBroker::Api::Representors::PactCollectionRepresenter)
        pacts.to_json
      end

      def handle_exception e
        PactBroker::Resources::ErrorHandler.handle_exception(e, response)
      end

      private

      def create_representable_pact pact
        PactBroker::Api::Representors::RepresentablePact.new(pact)
      end

    end
  end

end
