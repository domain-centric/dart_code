// Copyright (c) 2025 Nils ten Hoeve, licensed under the 3-Clause BSD License
import 'package:dart_code/dart_code.dart';
import 'package:shouldly/shouldly.dart';
import 'package:test/test.dart';

void main() {
  group('Comment class', () {
    group('Comment.fromString() constructor', () {
      test("Should return: '// Single line comment\n'", () {
        var comment = 'Single line comment';
        Comment.fromString(comment)
            .toString()
            .should
            .be('// ' + comment + '\n');
      });

      test("Should return: '// Single long line comment (80 characters)\n'",
          () {
        final longLineComment =
            'Single long line comment ' + ('0123456789' * 8);
        Comment.fromString(longLineComment)
            .toString()
            .should
            .be('// ' + longLineComment + '\n');
      });

      test("Should return: '// Single line comment with leading slashes\n'",
          () {
        var commentText = 'Single line comment with leading slashes';
        var commentWithLeadingSlashes = '/// ' + commentText;
        Comment.fromString(commentWithLeadingSlashes)
            .toString()
            .should
            .be('// ' + commentText + '\n');
      });

      test(
          "Should return: '// comment1\n// comment2\n// comment3\n// comment4\n'",
          () {
        Comment.fromString('comment1\ncomment2\rcomment3\r\ncomment4')
            .toString()
            .should
            .be('// comment1\n// comment2\n// comment3\n// comment4\n');
      });
    });

    group('Comment.fromList() constructor', () {
      test("Should return: '// Single line comment\n'", () {
        var comment = 'Single line comment';
        Comment.fromList([comment, comment])
            .toString()
            .should
            .be('// ' + comment + '\n' + '// ' + comment + '\n');
      });

      test("Should return: '// Single long line comment (80 characters)\n'",
          () {
        final longLineComment =
            'Single long line comment ' + ('0123456789' * 8);
        Comment.fromList([longLineComment, longLineComment])
            .toString()
            .should
            .be('// ' +
                longLineComment +
                '\n' +
                '// ' +
                longLineComment +
                '\n');
      });

      test("Should return: '// Single line comment with leading slashes\n'",
          () {
        var commentText = 'Single line comment with leading slashes';
        var commentWithLeadingSlashes = '/// ' + commentText;
        Comment.fromList([commentWithLeadingSlashes, commentWithLeadingSlashes])
            .toString()
            .should
            .be('// ' + commentText + '\n' + '// ' + commentText + '\n');
      });

      test(
          "Should return: '// comment1\n// comment2\n// comment3\n// comment4\n'",
          () {
        Comment.fromList(['comment1\ncomment2\r', 'comment3\r\ncomment4'])
            .toString()
            .should
            .be('// comment1\n// comment2\n// comment3\n// comment4\n');
      });
    });
  });

  group('DocComment class', () {
    group('Comment.fromString() constructor', () {
      test("Should return: 2x'/// Single line comment\n'", () {
        var comment = 'Single line comment';
        DocComment.fromString(comment)
            .toString()
            .should
            .be('/// ' + comment + '\n');
      });

      test("Should return: 2x'/// Single long line comment (80 characters)\n'",
          () {
        final longLineComment =
            'Single long line comment ' + ('0123456789' * 8);
        DocComment.fromString(longLineComment)
            .toString()
            .should
            .be('/// ' + longLineComment + '\n');
      });

      test("Should return: 2x'/// Single line comment with leading slashes\n'",
          () {
        var commentText = 'Single line comment with leading slashes';
        var commentWithLeadingSlashes = '/// ' + commentText;
        DocComment.fromString(commentWithLeadingSlashes)
            .toString()
            .should
            .be('/// ' + commentText + '\n');
      });

      test(
          "Should return: '/// comment1\n/// comment2\n/// comment3\n/// comment4\n'",
          () {
        DocComment.fromString('comment1\ncomment2\rcomment3\r\ncomment4')
            .toString()
            .should
            .be('/// comment1\n/// comment2\n/// comment3\n/// comment4\n');
      });
    });

    group('Comment.fromList() constructor', () {
      test("Should return: 2x'/// Single line comment\n'", () {
        var comment = 'Single line comment';
        DocComment.fromList([comment, comment])
            .toString()
            .should
            .be('/// ' + comment + '\n' + '/// ' + comment + '\n');
      });

      test("Should return: 2x'/// Single long line comment (80 characters)\n'",
          () {
        final longLineComment =
            'Single long line comment ' + ('0123456789' * 8);
        DocComment.fromList([longLineComment, longLineComment])
            .toString()
            .should
            .be('/// ' +
                longLineComment +
                '\n' +
                '/// ' +
                longLineComment +
                '\n');
      });

      test("Should return: 2x'/// Single line comment with leading slashes\n'",
          () {
        var commentText = 'Single line comment with leading slashes';
        var commentWithLeadingSlashes = '/// ' + commentText;
        DocComment.fromList(
                [commentWithLeadingSlashes, commentWithLeadingSlashes])
            .toString()
            .should
            .be('/// ' + commentText + '\n' + '/// ' + commentText + '\n');
      });

      test(
          "Should return: '/// comment1\n/// comment2\n/// comment3\n/// comment4\n'",
          () {
        DocComment.fromList(['comment1\ncomment2\r', 'comment3\r\ncomment4'])
            .toString()
            .should
            .be('/// comment1\n/// comment2\n/// comment3\n/// comment4\n');
      });
    });
  });
}
