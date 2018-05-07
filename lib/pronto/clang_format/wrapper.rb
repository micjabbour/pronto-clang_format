require 'open3'
require 'rexml/document'
require 'shellwords'
require_relative 'offence'

module Pronto
  module ClangFormat
    class Wrapper
      def initialize
        @clang_format_path = ENV['PRONTO_CLANG_FORMAT_PATH'] || 'clang-format'
      end

      # runs clang-format for the provided file and returns an array of
      # offence objects
      # Params:
      # - file_path: path to the file to be examined by clang-format
      def run(file_path)
        stdout, stderr, = Open3.capture3("#{@clang_format_path} "\
                                         "-style=#{style} "\
                                         "-output-replacements-xml "\
                                         "#{file_path}")
        if stderr && !stderr.empty?
          puts "WARN: pronto-clang_format: #{file_path}: #{stderr}"
        end
        return [] if stdout.nil? || stdout == 0
        parse_output(file_path, stdout)
      end

      private

      def style
        ENV['PRONTO_CLANG_FORMAT_STYLE'] || 'file'
      end

      # parses clang-format output for a given file and returns an array of
      # offence objects
      # Params:
      # - file_path: file path for which clang-format generated the output
      # - output: clang-format standard output for the given file path
      def parse_output(file_path, output)
        file_contents = File.read(file_path, mode: 'r')
        newlines_array = newline_offsets_in(file_contents)
        doc = REXML::Document.new output
        doc.root.elements.map do |element|
          offset = element.attributes['offset'].to_i
          length = element.attributes['length'].to_i
          line_no, column = ln_col_from_offset(newlines_array, offset)
          replacement = element.get_text ? element.get_text.value : ''
          # remove non-changed new lines from the beginning of the replacement
          while replacement.start_with?("\n") && column.zero? && length > 0
            offset += 1
            length -= 1
            line_no, column = ln_col_from_offset(newlines_array, offset)
            replacement = replacement[1..-1]
          end
          # calculate number of the last line affected by the replacement
          end_line_no, = ln_col_from_offset(newlines_array, offset + length)
          # extract relevant lines and pass to offence
          start_offset = offset_from_ln_col(newlines_array, line_no, 1)
          end_offset = offset_from_ln_col(newlines_array, end_line_no + 1, -1)
          old_lines_text = "\n#{file_contents[start_offset..end_offset]}\n"
          Offence.new(offset, line_no, column, length, replacement,
                      old_lines_text)
        end
      end

      # returns line no and column given byte offset in a text file
      # Params:
      # - newlines_array: an array that contains offsets of newline
      #   characters in the text file (can be obtained by calling
      #   newline_offsets_in(file_contents)
      # - offset: offset to be converted
      def ln_col_from_offset(newlines_array, offset)
        preceding_newlines = newlines_array
                             .select { |newline| newline <= offset }
        ln = preceding_newlines.length + 1
        line_start_offset = preceding_newlines.last || -1
        col = offset - line_start_offset
        [ln, col]
      end

      # returns byte offset given line no and a column in a text file
      # Params:
      # - newlines_array: an array that contains offsets of newline
      #   characters in the text file (can be obtained by calling
      #   newline_offsets_in(file_contents)
      # - offset: offset to be converted
      def offset_from_ln_col(newlines_array, ln, col)
        # return -1 if the line does not exist in file
        return -1 unless ln - 2 < newlines_array.length
        (ln >= 2 ? newlines_array[ln - 2] : -1) + col
      end

      # returns an array that contains offsets of newline characters in given
      # text
      def newline_offsets_in(text)
        (0..(text.length - 1)).select { |i| text[i] == "\n" }
      end
    end
  end
end
