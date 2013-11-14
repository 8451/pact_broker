require_relative 'base_decorator'

module PactBroker
  module Api
    module Decorators
      class VersionRepresenter < BaseDecorator

        property :number

        link :self do
          version_url(represented)
        end
      end
    end
  end
end