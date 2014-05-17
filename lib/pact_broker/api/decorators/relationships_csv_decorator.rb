require 'csv'
require 'set'

module PactBroker

  module Api

    module Decorators

      class RelationshipsCsvDecorator

        def initialize pacts
          @pacts = pacts
          @relationships = pacts.collect{|pact| PactBroker::Models::Relationship.new(pact.consumer,pact.provider)}
        end

        def to_csv
          hash = {}
          pacticipants = @relationships.collect{|r| r.pacticipants}.flatten.uniq
          puts pacticipants


          @relationships.each do | relationship |
            hash[relationship.consumer.id] ||= pacticipant_array(relationship.consumer, hash.size + 1)
            hash[relationship.provider.id] ||= pacticipant_array(relationship.provider, hash.size + 1)
            hash[relationship.consumer.id] << relationship.provider.id
          end

          max_length = hash.values.collect{|array| array.size}.max

          hash.values.each do | array |
            while array.size < max_length
              array << 0
            end
          end

          CSV.generate do |csv|
            hash.values.each do | array |
              csv << array
            end
          end

        end

        def pacticipant_array pacticipant, order
          [pacticipant.id, pacticipant.name,1,3158419, 0, order]
        end

        def to_csv_old
          CSV.generate do |csv|
            csv << ["source", "target", "weight"]
            pacts.each do | pact |
              csv << [pact.consumer.name, pact.provider.name, 1]
            end
          end
        end

        private

        attr_accessor :pacts

      end
    end
  end
end