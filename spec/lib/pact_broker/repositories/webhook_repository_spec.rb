require 'spec_helper'
require 'pact_broker/repositories/webhook_repository'

module PactBroker
  module Repositories
    describe WebhookRepository do

      describe "#create" do

        let(:url) { 'http://example.org' }
        let(:body) { {'some' => 'json' } }
        let(:headers) { {'Content-Type' => 'application/json', 'Accept' => 'application/json'} }
        let(:request) { Models::WebhookRequest.new(method: 'post', url: url, headers: headers, body: body)}
        let(:webhook) { Models::Webhook.new(request: request)}
        let(:test_data_builder) { ProviderStateBuilder.new }
        let(:consumer) { test_data_builder.create_pacticipant 'Consumer'; test_data_builder.pacticipant}
        let(:provider) { test_data_builder.create_pacticipant 'Provider'; test_data_builder.pacticipant}
        let(:uuid) { 'the-uuid' }
        let(:created_webhook_record) { ::DB::PACT_BROKER_DB[:webhooks].order(:id).last }
        let(:created_headers) { ::DB::PACT_BROKER_DB[:webhook_headers].where(webhook_id: created_webhook_record[:id]).order(:name).all }
        let(:expected_webhook_record) { {
          :uuid=>"the-uuid",
          :method=>"post",
          :url=>"http://example.org",
          :body=>body.to_json,
          :consumer_id=> consumer.id,
          :provider_id=> provider.id } }

        subject { WebhookRepository.new.create webhook, consumer, provider }

        before do
          allow(SecureRandom).to receive(:urlsafe_base64).and_return(uuid)
        end

        it "generates a UUID" do
          expect(SecureRandom).to receive(:urlsafe_base64)
          subject
        end

        it "saves webhook" do
          subject
          expect(created_webhook_record).to include expected_webhook_record
        end

        it "saves the headers" do
          subject
          expect(created_headers.size).to eq 2
          expect(created_headers.first[:name]).to eq "Accept"
          expect(created_headers.first[:value]).to eq "application/json"
          expect(created_headers.last[:name]).to eq "Content-Type"
          expect(created_headers.last[:value]).to eq "application/json"
        end

        it "returns a webhook with the consumer set" do
          expect(subject.consumer.id).to eq consumer.id
          expect(subject.consumer.name).to eq consumer.name
        end

        it "returns a webhook with the provider set" do
          expect(subject.provider.id).to eq provider.id
          expect(subject.provider.name).to eq provider.name
        end

        it "returns a webhook with the uuid set" do
          expect(subject.uuid).to eq uuid
        end

        it "returns a webhook with the body set" do
          expect(subject.request.body).to eq body
        end

        it "returns a webhook with the headers set" do
          expect(subject.request.headers).to eq headers
        end

        it "returns a webhook with the url set" do
          expect(subject.request.url).to eq url
        end
      end

    end
  end
end