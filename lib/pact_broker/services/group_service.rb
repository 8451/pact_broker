require 'pact_broker/repositories'
require 'pact_broker/functions/groupify'

module PactBroker

  module Services
    module GroupService

      extend self

      extend PactBroker::Repositories
      extend PactBroker::Services

      def find_group_containing pacticipant
        groups.find { | group | group.include_pacticipant? pacticipant }
      end

      def groups
        Functions::Groupify.call pacticipant_service.find_relationships
      end

    end
  end
end