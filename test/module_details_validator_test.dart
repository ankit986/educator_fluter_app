import 'package:educator/screens/Module_Details_Screen.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('Module_Details_Validator', () {
    test('Empty Module Title Return String', () {
      var result = Validator.validateModuleTitle('');
      expect(result, 'Please Enter Module Price');
    });

    test('Empty Module Description Return String', () {
      var result = Validator.validateModuleDescription('');
      expect(result, 'Please Enter Module Title');
    });
  });
}
