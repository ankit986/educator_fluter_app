import 'dart:async';

import 'package:educator/sqlite/course_info.dart';
import 'package:educator/sqlite/db_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:sqflite/sqflite.dart';

class MockDatabase extends Mock implements DbHelper {}

void main() {
  MockDatabase _mockDatabase = MockDatabase();

  setUp(() {
    _mockDatabase = MockDatabase();
  });

  test('Empty Database Should Return Null ', () async {
    Course_Info courseInfo = Course_Info(
        course_id: "FlutterBasics_1608717279169081",
        course_title: "Flutter Basics",
        created_at: DateTime.now(),
        course_price: 499);
    MockDatabase().insertCourse(courseInfo);
    when(_mockDatabase.insertCourse(courseInfo))
        .thenAnswer((realInvocation) => Future.value([courseInfo]));

    Future<List<Course_Info>> c = _mockDatabase.getCourses();

    expect(await _mockDatabase.getCourses(), isA<Database>());
  });
}
