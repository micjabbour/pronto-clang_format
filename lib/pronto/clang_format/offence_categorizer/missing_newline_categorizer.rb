require_relative 'abstract_categorizer'

module Pronto
  module ClangFormat
    module OffenceCategorizer
      class MissingNewlineCategorizer < AbstractCategorizer
        def handle_current(offence)
          return unless offence.replaced_text.count("\n") \
                      < offence.replacement.count("\n")

          "Missing newline. This should be rewritten as:\n" \
          "```#{offence.affected_lines_after}```"
        end
      end
    end
  end
end
