import 'package:flutter_test/flutter_test.dart';

bool isValidEmail(String email) {
  return email.contains('@') && email.contains('.');
}

void main() {
  test('Проверка корректного email', () {
    expect(isValidEmail('test@gmail.com'), true);
  });

  test('Проверка некорректного email', () {
    expect(isValidEmail('testgmail.com'), false);
  });
}