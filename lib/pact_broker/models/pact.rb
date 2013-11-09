require 'sequel'

module PactBroker

  module Models
    class Pact < Sequel::Model

      associate(:many_to_one, :provider, :class => "PactBroker::Models::Pacticipant", :key => :id, :primary_key => :provider_id)
      associate(:many_to_one, :consumer_version, :class => "PactBroker::Models::Version", :key => :version_id, :primary_key => :id)

      #Need to work out how to do this properly!
      def consumer_version_number
        values[:consumer_version_number]
      end

      def to_s
        "Pact: provider_id=#{provider_id}"
      end

      def to_json options = {}
        json_content
      end
    end
  end
end
