require_relative 'offence_categorizer/factory'

module Pronto
  module ClangFormat
    class Offence
      attr_reader :offset, :line_no, :column, :length, :replacement,
                  :affected_lines_before
      def initialize(offset, line_no, column, length, replacement,
                     affected_lines)
        @offset = offset.freeze
        @line_no = line_no.freeze
        @column = column.freeze
        @length = length.freeze
        @replacement = replacement.freeze
        @affected_lines_before = affected_lines.freeze
      end

      # generates a user-friendly message that describes this offence. This is
      # done by using OffenceCategorizer's chain of responsibility classes
      def msg
        OffenceCategorizer::Factory.create_categorizers.handle self
      end

      # the exact portion of text that is to be replaced by this offence
      def replaced_text
        affected_lines_before[column..(column + length - 1)]
      end

      # returns the range of line numbers affected by this offence
      def affected_lines_range
        (line_no..line_no + replaced_text.count("\n"))
      end

      # returns affected lines after fixing this offence
      def affected_lines_after
        affected_lines = String.new(affected_lines_before)
        affected_lines[column..(column + length - 1)] = replacement
        affected_lines
      end
    end
  end
end
