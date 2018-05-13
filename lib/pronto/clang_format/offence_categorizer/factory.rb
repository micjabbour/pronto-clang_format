# require all ruby files in the current directory (all categorizers)
Dir[File.join(__dir__, '*.rb')].each { |file| require file }

module Pronto
  module ClangFormat
    module OffenceCategorizer
      class Factory
        def self.create_categorizers
          IncludesOrderCategorizer.new UnnecessaryNewlineCategorizer.new \
          IndentationCategorizer.new MissingNewlineCategorizer.new
        end
      end
    end
  end
end
