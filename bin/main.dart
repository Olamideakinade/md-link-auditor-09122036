import 'dart:io';
import 'package:args/args.dart';
import 'package:md_link_auditor/src/scanner.dart';

void main(List<String> arguments) async {
  final parser = ArgParser()
    ..addOption('path', abbr: 'p', defaultsTo: '.', help: 'Target directory')
    ..addFlag('verbose', abbr: 'v', help: 'Show detailed output');
  
  final results = parser.parse(arguments);
  final scanner = LinkScanner();
  
  stdout.writeln('\x1B[36mAuditing links in: ${results['path']}\x1B[0m');
  final errors = await scanner.scan(results['path']);

  if (errors.isNotEmpty) {
    for (final err in errors) {
      stderr.writeln('\x1B[31m[BROKEN]\x1B[0m ${err.file}:${err.line} -> ${err.url}');
    }
    exit(1);
  }
  stdout.writeln('\x1B[32mSuccess: No broken links found.\x1B[0m');
}