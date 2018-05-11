# Pronto runner for clang-format

[![Code Climate](https://codeclimate.com/github/micjabbour/pronto-clang_format.png)](https://codeclimate.com/github/micjabbour/pronto-clang_format)
[![Build Status](https://travis-ci.org/micjabbour/pronto-clang_format.png)](https://travis-ci.org/micjabbour/pronto-clang_format)
[![Gem Version](https://badge.fury.io/rb/pronto-clang_format.png)](http://badge.fury.io/rb/pronto-clang_format)
[![Dependency Status](https://gemnasium.com/micjabbour/pronto-clang_format.png)](https://gemnasium.com/micjabbour/pronto-clang_format)

Pronto runner for [clang-format](https://clang.llvm.org/docs/ClangFormat.html), a tool to reformat C/C++/Java/JavaScript/Objective-C/Protobuf code according to configurable style guidelines. [What is Pronto?](https://github.com/prontolabs/pronto)

As an example, this can be used to run clang-format and submit replacements to web-based git repo managers (e.g. github, gitlab, ...) as comments using Pronto.

## Installation:

First, the following prerequisites need to be installed:

 1. clang-format
 2. Ruby
 3. Pronto, this can be done after installing Ruby using:
    ```
    gem install pronto
    ```
After that, pronto-clang_format can be installed using:
```
gem install pronto-clang_format
```
Pronto will detect and run clang-format as soon as this runner is installed.

## Configuration:

The runner can be configured by setting some environment variables before invoking it. The following table lists these environment
variables along with a description for each one of them:

| Environment variable           | Description                                                                                           |
|:-------------------------------|:------------------------------------------------------------------------------------------------------|
| `PRONTO_CLANG_FORMAT_PATH`     | Path to the clang-format executable that should be run by the runner. This defaults to `clang-format` |
| `PRONTO_CLANG_FORMAT_STYLE`    | A string that is passed to clang-format's `--style=` option. This defaults to `file`                  |
| `PRONTO_CLANG_FORMAT_FILE_EXTS`| A comma separated list of file extensions to examine. This defaults to `c, h, cpp, cc, cxx, c++, hh, hxx, hpp, h++, icc, inl, tcc, tpp, ipp`|
