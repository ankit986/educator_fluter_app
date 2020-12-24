import 'package:educator/screens/New_Course_Screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('New_Course_Validator', () {
    test('Empty Course Price Return String', () {
      var result = Validator.validateCoursePrice('');
      expect(result, 'Please Enter Course Price');
    });

    test('Empty Course Price Return String', () {
      var result = Validator.validateCoursePrice('abc');
      expect(result, 'Please Enter Number only');
    });

    test('Empty Course Price Return String', () {
      var result = Validator.validateCourseTitle('');
      expect(result, 'Please Enter Course Title');
    });
  });
}
