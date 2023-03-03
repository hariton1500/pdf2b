import 'dart:io';

import 'package:pdf2b/pdf2b.dart' as pdf2b;

void main(List<String> arguments) {
  print('Pdf to clients creator.');
  print('args: $arguments');
  if (arguments.isEmpty) {
    print('usage: runfile.dart -bill -akt');
    exit(0);
  }
  pdf2b.run(arguments);
}
