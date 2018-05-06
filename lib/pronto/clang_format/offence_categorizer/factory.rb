require_relative 'indentation_categorizer'
require_relative 'includes_order_categorizer'

module Pronto
  module ClangFormat
    module OffenceCategorizer
      class Factory
        def self.create_categorizers
          IncludesOrderCategorizer.new IndentationCategorizer.new
        end
      end
    end
  end
end
