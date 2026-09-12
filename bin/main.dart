import 'dart:io';
import 'package:args/args.dart';
import 'package:md_link_auditor/src/scanner.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()..addOption('path', abbr: 'p', help: 'Target directory');
  final results = parser.parse(arguments);
  final path = results['path'] ?? '.';

  final scanner = LinkScanner();
  final errors = await scanner.scan(path);

  if (errors.isNotEmpty) {
    for (final err in errors) {
      stdout.writeln('Broken link in ${err.file}:${err.line} - ${err.url}');
    }
    exit(1);
  }
  stdout.writeln('No broken links found.');
  exit(0);
}