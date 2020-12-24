import 'dart:convert';

import 'package:educator/services/rest_api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;

class MockClient extends Mock implements http.Client {}

void main() {
  group('fetch API testing', () {
    test(
        'returns a CourseInfoList if the http call to API for course completes successfully',
        () async {
      final client = MockClient();

      var dynamicData =
          '{"courses":[{"course_id":"ReactAdvaced_1608573941193540","course_title":"React Advaced","created_at":"2020-12-21T23:35:12.351Z","course_price":198}]}';
      // Use Mockito to return a successful response when it calls the
      // provided http.Client.

      when(client.get('https://dummy-api-employee.herokuapp.com/api/course'))
          .thenAnswer((_) async => http.Response(dynamicData, 200));

      expect(await fetchCourse(client), isA<CourseInfoList>());
    });

    test(
        'returns a ModuleInfoList if the http call to API for module completes successfully',
        () async {
      final client = MockClient();

      var dynamicData = '''{"modules": [{
          "module_id": "ReactAdvaced608573941193540_Whatiscomponent_1608573973897",
          "course_id": "ReactAdvaced_1608573941193540",
          "module_name": "What is component?",
          "module_description": "Smallest Part of React"
          }]}''';

      // Use Mockito to return a successful response when it calls the
      // provided http.Client.

      when(client.get('https://dummy-api-employee.herokuapp.com/api/module'))
          .thenAnswer((_) async => http.Response(dynamicData, 200));

      expect(await fetchModule(client), isA<ModuleInfoList>());
    });
  });
}

//USING CLIENT IN ORIGINAL API
Future<CourseInfoList> fetchCourse(http.Client client) async {
  final url = 'https://dummy-api-employee.herokuapp.com/api/course';
  final response = await client.get(url);

  if (response.statusCode == 200) {
    final jsonCourse = jsonDecode(response.body);
    return CourseInfoList.fromJson(jsonCourse);
  } else {
    throw Exception(
        'Error In file rest_api_service.dart  Error while Fetching All Courses');
  }
}

//USING CLIENT IN ORIGINAL API
Future<ModuleInfoList> fetchModule(http.Client client) async {
  final url = 'https://dummy-api-employee.herokuapp.com/api/module';
  final response = await client.get(url);

  if (response.statusCode == 200) {
    final jsonCourse = jsonDecode(response.body);

    return ModuleInfoList.fromJson(jsonCourse);
  } else {
    throw Exception(
        'Error In file rest_api_service.dart  Error while Fetching All Courses');
  }
}
