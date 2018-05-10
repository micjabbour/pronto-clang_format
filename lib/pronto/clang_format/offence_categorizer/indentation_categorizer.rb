require_relative 'abstract_categorizer'

module Pronto
  module ClangFormat
    module OffenceCategorizer
      class IndentationCategorizer < AbstractCategorizer
        def handle_current(offence)
          return unless offence.column <= 1

          "Incorrect indentation"
        end
      end
    end
  end
end
