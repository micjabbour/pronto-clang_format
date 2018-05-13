require_relative 'abstract_categorizer'

module Pronto
  module ClangFormat
    module OffenceCategorizer
      class IncludesOrderCategorizer < AbstractCategorizer
        def handle_current(offence)
          return unless offence.replaced_text.include? 'include'

          "Include statements are not ordered alphabetically. "\
          "They should be rewritten as:\n" \
          "```#{offence.affected_lines_after}```"
        end
      end
    end
  end
end
