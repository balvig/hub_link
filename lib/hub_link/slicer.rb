require "active_support/core_ext/hash"

module HubLink
  class Slicer
    def initialize(record, columns: [])
      @record = record
      @columns = columns
    end

    def to_h
      normalized_attributes.with_indifferent_access
    end

    private

      attr_reader :record, :columns

      def normalized_attributes
        raw_attributes.transform_keys { |key| key.to_s.chomp("?").to_sym }
      end

      def raw_attributes
        columns.inject({}) do |result, column|
          result.merge(column => record.public_send(column))
        end
      end
  end
end
