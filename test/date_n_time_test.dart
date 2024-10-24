import 'package:date_n_time/date_n_time.dart';
import 'package:date_n_time/src/local_time.dart';
import 'package:test/test.dart';

void main() {
  test('description', () {
    final time = LocalTime(10, 90, 90);
    expect(time.hour, 11);
    expect(time.minute, 31);
    expect(time.seconds, 30);
  });
}
