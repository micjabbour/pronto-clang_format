module Pronto
  module ClangFormat
    module OffenceCategorizer
      # base class to implement a chain of categorizers
      class AbstractCategorizer
        def initialize(successor = nil)
          @successor = successor
        end

        # Tries to handle the offence using the current categorizer. If it
        # couldn't, it passes the offence to the next categorizer in the chain.
        # If this is the last categorizer in the chain, it returns a generic
        # message
        def handle(offence)
          current_result = handle_current offence
          if !current_result.nil?
            current_result
          elsif !@successor.nil?
            @successor.handle offence
          else # unahndled offence
            "Improper formatting. This should be rewritten as: \n" \
            "```#{offence.affected_lines_after}```"
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
