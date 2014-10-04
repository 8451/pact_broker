require 'spec_helper'
require 'pact_broker/api/renderers/html_pact_renderer'

module PactBroker
  module Api
    module Renderers
      describe HtmlPactRenderer do

        before do
          ENV['BACKUP_TZ'] = ENV['TZ']
          ENV['TZ'] = "Australia/Melbourne"
        end

        after do
          ENV['TZ'] = ENV['BACKUP_TZ']
        end

        let(:consumer) { double('consumer', name: 'Consumer')}
        let(:created_at) { DateTime.new(2014, 02, 27) }
        let(:json_content) { load_fixture('renderer_pact.json') }
        let(:pact) { double('pact', json_content: json_content, updated_at: created_at, consumer_version_number: '1.2.3', consumer: consumer)}
        let(:pact_url) { '/pact/url' }

        before do
          allow(PactBroker::Api::PactBrokerUrls).to receive(:pact_url).with('', pact).and_return(pact_url)
        end

        subject { HtmlPactRenderer.call pact }

        describe ".call" do
          it "renders the pact as HTML" do
            expect(subject).to include("<html>")
            expect(subject).to include("</html>")
            expect(subject).to include("<link rel='stylesheet'")
            expect(subject).to include("href='/stylesheets/github.css'")
            expect(subject).to include('<pre><code')
            expect(subject).to include('&quot;method&quot;:')
            expect(subject).to match /<h\d>.*Some Consumer/
            expect(subject).to match /<h\d>.*Some Provider/
            expect(subject).to include("Date published:")
            expect(subject).to include("27/02/2014 11:00AM +11:00")
          end
        end

      end
    end
  end
end