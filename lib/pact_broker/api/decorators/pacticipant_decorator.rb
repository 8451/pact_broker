require_relative 'base_decorator'
require_relative 'version_decorator'

module PactBroker

  module Api

    module Decorators

      class PacticipantRepresenter < BaseDecorator

        property :name
        property :repository_url

        property :last_version, :class => PactBroker::Models::Version, :extend => PactBroker::Api::Decorators::VersionRepresenter, :embedded => true

        link :self do
          pacticipant_url(represented)
        end

        link :last_version do
          last_version_url(represented)
        end

        link :versions do
          versions_url(represented)
        end

      end
    end
  end
end