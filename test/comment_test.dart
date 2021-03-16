import 'package:dart_code/comment.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  group('Comment class', () {
    group('Comment.fromString() constructor', () {
      test("Should return: '// Single line comment\n'", () {
        var comment = 'Single line comment';
        String actual = Comment.fromString(comment).toString();
        String expected = '// ' + comment + '\n';
        expect(actual, expected);
      });

      test("Should return: '// Single long line comment (80 characters)\n'",
          () {
        final longLineComment =
            'Single long line comment ' + ('0123456789' * 8);
        String actual = Comment.fromString(longLineComment).toString();
        String expected = '// ' + longLineComment + '\n';
        expect(actual, expected);
      });

      test("Should return: '// Single line comment with leading slashes\n'",
          () {
        var commentText = 'Single line comment with leading slashes';
        var commentWithLeadingSlashes = '/// ' + commentText;
        String actual =
            Comment.fromString(commentWithLeadingSlashes).toString();
        String expected = '// ' + commentText + '\n';
        expect(actual, expected);
      });

      test(
          "Should return: '// comment1\n// comment2\n// comment3\n// comment4\n'",
          () {
        String actual =
            Comment.fromString('comment1\ncomment2\rcomment3\r\ncomment4')
                .toString();
        String expected =
            '// comment1\n// comment2\n// comment3\n// comment4\n';
        expect(actual, expected);
      });
    });

    group('Comment.fromList() constructor', () {
      test("Should return: '// Single line comment\n'", () {
        var comment = 'Single line comment';
        String actual = Comment.fromList([comment, comment]).toString();
        String expected = '// ' + comment + '\n' + '// ' + comment + '\n';
        expect(actual, expected);
      });

      test("Should return: '// Single long line comment (80 characters)\n'",
          () {
        final longLineComment =
            'Single long line comment ' + ('0123456789' * 8);
        String actual =
            Comment.fromList([longLineComment, longLineComment]).toString();
        String expected =
            '// ' + longLineComment + '\n' + '// ' + longLineComment + '\n';
        expect(actual, expected);
      });

      test("Should return: '// Single line comment with leading slashes\n'",
          () {
        var commentText = 'Single line comment with leading slashes';
        var commentWithLeadingSlashes = '/// ' + commentText;
        String actual = Comment.fromList(
            [commentWithLeadingSlashes, commentWithLeadingSlashes]).toString();
        String expected =
            '// ' + commentText + '\n' + '// ' + commentText + '\n';
        expect(actual, expected);
      });

      test(
          "Should return: '// comment1\n// comment2\n// comment3\n// comment4\n'",
          () {
        String actual =
            Comment.fromList(['comment1\ncomment2\r', 'comment3\r\ncomment4'])
                .toString();
        String expected =
            '// comment1\n// comment2\n// comment3\n// comment4\n';
        expect(actual, expected);
      });
    });
  });

  group('DocComment class', () {
    group('Comment.fromString() constructor', () {
      test("Should return: 2x'/// Single line comment\n'", () {
        var comment = 'Single line comment';
        String actual = DocComment.fromString(comment).toString();
        String expected = '/// ' + comment + '\n';
        expect(actual, expected);
      });

      test("Should return: 2x'/// Single long line comment (80 characters)\n'",
          () {
        final longLineComment =
            'Single long line comment ' + ('0123456789' * 8);
        String actual = DocComment.fromString(longLineComment).toString();
        String expected = '/// ' + longLineComment + '\n';
        expect(actual, expected);
      });

      test("Should return: 2x'/// Single line comment with leading slashes\n'",
          () {
        var commentText = 'Single line comment with leading slashes';
        var commentWithLeadingSlashes = '/// ' + commentText;
        String actual =
            DocComment.fromString(commentWithLeadingSlashes).toString();
        String expected = '/// ' + commentText + '\n';
        expect(actual, expected);
      });

      test(
          "Should return: '/// comment1\n/// comment2\n/// comment3\n/// comment4\n'",
          () {
        String actual =
            DocComment.fromString('comment1\ncomment2\rcomment3\r\ncomment4')
                .toString();
        String expected =
            '/// comment1\n/// comment2\n/// comment3\n/// comment4\n';
        expect(actual, expected);
      });
    });

    group('Comment.fromList() constructor', () {
      test("Should return: 2x'/// Single line comment\n'", () {
        var comment = 'Single line comment';
        String actual = DocComment.fromList([comment, comment]).toString();
        String expected = '/// ' + comment + '\n' + '/// ' + comment + '\n';
        expect(actual, expected);
      });

      test("Should return: 2x'/// Single long line comment (80 characters)\n'",
          () {
        final longLineComment =
            'Single long line comment ' + ('0123456789' * 8);
        String actual =
            DocComment.fromList([longLineComment, longLineComment]).toString();
        String expected =
            '/// ' + longLineComment + '\n' + '/// ' + longLineComment + '\n';
        expect(actual, expected);
      });

      test("Should return: 2x'/// Single line comment with leading slashes\n'",
          () {
        var commentText = 'Single line comment with leading slashes';
        var commentWithLeadingSlashes = '/// ' + commentText;
        String actual = DocComment.fromList(
            [commentWithLeadingSlashes, commentWithLeadingSlashes]).toString();
        String expected =
            '/// ' + commentText + '\n' + '/// ' + commentText + '\n';
        expect(actual, expected);
      });

      test(
          "Should return: '/// comment1\n/// comment2\n/// comment3\n/// comment4\n'",
          () {
        String actual = DocComment.fromList(
            ['comment1\ncomment2\r', 'comment3\r\ncomment4']).toString();
        String expected =
            '/// comment1\n/// comment2\n/// comment3\n/// comment4\n';
        expect(actual, expected);
      });
    });
  });
}
