require 'versionomy'

module PactBroker
  module Models
    class SortVersions

      def self.call pacticipant_id
        versions = PactBroker::Models::Version.where(:pacticipant_id => pacticipant_id).all.collect{| version | SortableVersion.new(version) }
        versions.sort.each_with_index{ | version, i | version.update_model(i) }
      end

      class SortableVersion

        attr_accessor :version_model, :sortable_number

        def initialize version_model
          @version_model = version_model
          @sortable_number = Versionomy.parse(version_model.number)
        end

        def <=> other
          self.sortable_number <=> other.sortable_number
        end

        def update_model new_order
          version_model.update(:order => new_order)
        end
      end
    end
  end
end