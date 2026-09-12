import 'dart:io';
import 'package:glob/glob.dart';
import 'package:glob/list_local_fs.dart';
import 'verifier.dart';

class LinkError {
  final String file;
  final int line;
  final String url;
  LinkError(this.file, this.line, this.url);
}

class LinkScanner {
  Future<List<LinkError>> scan(String directory) async {
    final errors = <LinkError>[];
    final pattern = Glob('$directory/**.md');
    final verifier = LinkVerifier();

    for (var entity in pattern.listSync()) {
      if (entity is File) {
        final content = entity.readAsLinesSync();
        for (var i = 0; i < content.length; i++) {
          final matches = RegExp(r'https?://[^\s)]+').allMatches(content[i]);
          for (final match in matches) {
            final url = match.group(0)!;
            if (!await verifier.isValid(url)) {
              errors.add(LinkError(entity.path, i + 1, url));
            }
          }
        }
      }
    }
    return errors;
  }
}