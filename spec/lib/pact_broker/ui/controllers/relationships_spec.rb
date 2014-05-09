require 'spec_helper'
require 'pact_broker/ui/controllers/relationships'

require 'rack/test'

module PactBroker
  module UI
    module Controllers
      describe Relationships do

        include Rack::Test::Methods

        let(:app) { Relationships }

        describe "/" do
          describe "GET" do

            let(:consumer) { instance_double("PactBroker::Models::Pacticipant", name: 'consumer_name')}
            let(:provider) { instance_double("PactBroker::Models::Pacticipant", name: 'provider_name')}
            let(:relationship) { PactBroker::Models::Relationship.new(consumer, provider)}
            let(:relationships) { [relationship] }

            before do
              allow(PactBroker::Services::PacticipantService).to receive(:find_relationships).and_return(relationships)
            end

            it "does something" do
              get "/"
              puts last_response.body
            end

          end
        end
      end
    end
  end
end