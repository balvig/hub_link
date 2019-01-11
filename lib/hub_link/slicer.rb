module HubLink
  class Slicer
    def initialize(record, columns: [])
      @record = record
      @columns = columns
    end

    def to_h
      columns.inject({}) do |result, column|
        result.merge(column => record.public_send(column))
      end
    end

    private

      attr_reader :record, :columns
  end
end
