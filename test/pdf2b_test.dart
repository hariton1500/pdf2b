import 'package:pdf2b/pdf2b.dart';
import 'package:test/test.dart';

void main(List<String> args) {
  print(args);
  test('calculate', () {
    expect(run(args), 42);
  });
}
