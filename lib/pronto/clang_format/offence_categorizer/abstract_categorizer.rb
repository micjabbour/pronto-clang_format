module Pronto
  module ClangFormat
    module OffenceCategorizer
      # base class to implement a chain of responsibility
      class AbstractCategorizer
        def initialize(successor = nil)
          @successor = successor
        end

        def handle(offence)
          current_result = handle_current offence
          if !current_result.nil?
            current_result
          elsif !@successor.nil?
            @successor.handle offence
          else # unahndled offence
            "This should be rewritten as: \n```" \
            "#{offence.affected_lines_after}```"
          end
        end

        def handle_current(_offence)
          raise NotImplementedError, 'this method needs to be implemented in '\
                                     'subclasses'
        end
      end
    end
  end
end
