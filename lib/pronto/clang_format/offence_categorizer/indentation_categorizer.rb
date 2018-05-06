require_relative 'abstract_categorizer'

module Pronto
  module ClangFormat
    module OffenceCategorizer
      class IndentationCategorizer < AbstractCategorizer
        def handle_current(offence)
          "Incorrect indentation" if offence.column <= 1
        end
      end
    end
  end
end
