require_relative 'abstract_categorizer'

module Pronto
  module ClangFormat
    module OffenceCategorizer
      class UnnecessaryNewlineCategorizer < AbstractCategorizer
        def handle_current(offence)
          return unless offence.column == 0

          "Unnecessary new line"
        end
      end
    end
  end
end
