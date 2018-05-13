require_relative 'abstract_categorizer'

module Pronto
  module ClangFormat
    module OffenceCategorizer
      class TrailingWhitespaceCategorizer < AbstractCategorizer
        def handle_current(offence)
          return unless /[[:blank:]]+[\n]/.match(offence.replaced_text)

          "Remove trailing whitespace"
        end
      end
    end
  end
end
