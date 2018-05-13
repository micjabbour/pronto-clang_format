require_relative 'abstract_categorizer'

module Pronto
  module ClangFormat
    module OffenceCategorizer
      class UsingOrderCategorizer < AbstractCategorizer
        def handle_current(offence)
          return unless offence.replaced_text.include? 'using'

          "Using declarations not ordered alphabetically"
        end
      end
    end
  end
end
