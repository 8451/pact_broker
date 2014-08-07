require 'spec_helper'
require 'pact_broker/models/webhook'

module PactBroker

  module Models

    describe Webhook do

      let(:consumer) { Pacticipant.new(name: 'Consumer')}
      let(:provider) { Pacticipant.new(name: 'Provider')}
      let(:request) { instance_double(PactBroker::Models::WebhookRequest)}
      subject { Webhook.new(request: request, consumer: consumer, provider: provider) }

      describe "#validate" do
        let(:errors) { ['errors'] }


        context "when the request is not present" do
          let(:request) { nil }

          it "returns an error message" do
            expect(subject.validate).to include "Missing required attribute 'request'"
          end
        end

        context "when the request is present" do

          it "validates the request" do
            expect(request).to receive(:validate).and_return(errors)
            expect(subject.validate).to eq errors
          end
        end
      end

      describe "description" do
        it "returns a description of the webhook" do
          expect(subject.description).to eq "A webhook for the pact between Consumer and Provider"
        end
      end
    end

  end

end
