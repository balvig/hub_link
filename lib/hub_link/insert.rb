module HubLink
  class Insert
    def initialize(row:, target:)
      @row = row
      @target = target
    end

    def run
      record.update! importable_attributes
    end

    private

      def record
        target.find_or_initialize_by(primary_key => primary_key_value)
      end

      def primary_key_value
        row[primary_key]
      end

      def primary_key
        target.primary_key
      end

      def importable_attributes
        row.slice(*target_columns)
      end

      def target_columns
        target.columns.map(&:name).map(&:to_sym)
      end

      attr_reader :row, :target
  end
end
