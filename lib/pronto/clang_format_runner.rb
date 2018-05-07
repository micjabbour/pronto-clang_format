require 'pronto'
require_relative 'clang_format/wrapper'

module Pronto
  class ClangFormatRunner < Runner
    def initialize(_, __ = nil)
      super
      @inspector = ::Pronto::ClangFormat::Wrapper.new
      comma_separated_exts = ENV['PRONTO_CLANG_FORMAT_FILE_EXTS']
      if comma_separated_exts.nil? # load default cpp files extensions
        @cpp_extensions = %w[c h cpp cc cxx c++ hh hxx hpp h++ icc inl tcc tpp
                             ipp]
      else # load desired extensions from environment variable
        @cpp_extensions = comma_separated_exts.split(',').map(&:strip)
      end
    end

    def run
      return [] if !@patches || @patches.count.zero?
      @patches
        .select { |p| valid_patch?(p) }
        .map { |p| inspect(p) }
        .flatten.compact
        .uniq { |message| message.line } # generate only one message per line
    end

    def valid_patch?(patch)
      return false if patch.additions < 1
      cpp_file?(patch.new_file_full_path)
    end

    def cpp_file?(file_path)
      @cpp_extensions.include? file_path.extname[1..-1]
    end

    def inspect(patch)
      file_path = patch.new_file_full_path
      offences = @inspector.run(file_path)
      offences.map do |offence|
        line = patch.added_lines.find do |added_line|
          offence.affected_lines_range.cover? added_line.new_lineno
        end
        new_message(offence, line) unless line.nil?
      end
    end

    def new_message(offence, line)
      path = line.patch.delta.new_file[:path]
      Message.new(path, line, :warning, offence.msg, nil, self.class)
    end
  end
end
