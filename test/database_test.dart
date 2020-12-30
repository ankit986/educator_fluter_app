import 'dart:async';

import 'package:educator/Model/course_info.dart';
import 'package:educator/Model/module_info.dart';
import 'package:educator/sqlite/db_helper.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

class MockDatabase extends Mock implements DbHelper {}

void main() {
  MockDatabase _mockDatabase = MockDatabase();
  Course_Info courseInfo = Course_Info(
      course_id: "FlutterBasics_1608717279169081",
      course_title: "Flutter Basics",
      created_at: DateTime.now(),
      course_price: 499);

  Module_Info moduleInfo = Module_Info(
      course_id: "course1",
      module_id: "course1_module1",
      moduleNumber: 1,
      module_name: "Welcome",
      module_description: "dd");

  setUp(() {
    _mockDatabase = MockDatabase();
  });

  group('Testing db_helper methods', () {
    group('Testing Methods For Courses', () {
      test('getCourses Method In Database Should Return List<Course_Info> ',
          () async {
        when(_mockDatabase.getCourses())
            .thenAnswer((realInvocation) => Future.value([courseInfo]));

        expect(await _mockDatabase.getCourses(), isA<List<Course_Info>>());
      });

      test(
          'getCourseBycourse_id Method In Database Should Return List<Course_Info> ',
          () async {
        when(_mockDatabase
                .getCourseBycourse_id("FlutterBasics_1608717279169081"))
            .thenAnswer((realInvocation) => Future.value([courseInfo]));

        expect(
            await _mockDatabase
                .getCourseBycourse_id("FlutterBasics_1608717279169081"),
            isA<List<Course_Info>>());
      });

      test('deleteCourse Method In Database Should Return int ', () async {
        when(_mockDatabase.deleteCourse("FlutterBasics_1608717279169081"))
            .thenAnswer((realInvocation) => Future.value(1));

        expect(
            await _mockDatabase.deleteCourse("FlutterBasics_1608717279169081"),
            isA<int>());
      });

      test('updateCourse Method In Database Should Return int ', () async {
        when(_mockDatabase.updateCourse(courseInfo))
            .thenAnswer((realInvocation) => Future.value(1));

        expect(await _mockDatabase.updateCourse(courseInfo), isA<int>());
      });
    });

    group('Testing Methods For Courses', () {
      test('getModules Method In Database Should Return List<Course_Info> ',
          () async {
        when(_mockDatabase.getModules())
            .thenAnswer((realInvocation) => Future.value([moduleInfo]));

        expect(await _mockDatabase.getModules(), isA<List<Module_Info>>());
      });

      test(
          'getModulesBycourse_id Method In Database Should Return List<Module_Info> ',
          () async {
        when(_mockDatabase.getModulesBycourse_id("course1"))
            .thenAnswer((realInvocation) => Future.value([moduleInfo]));

        expect(await _mockDatabase.getModulesBycourse_id("course1"),
            isA<List<Module_Info>>());
      });

      test(
          'getModulesBymodule_id Method In Database Should Return List<Module_Info> ',
          () async {
        when(_mockDatabase.getModulesBymodule_id("course1_module1"))
            .thenAnswer((realInvocation) => Future.value([moduleInfo]));

        expect(await _mockDatabase.getModulesBymodule_id("course1_module1"),
            isA<List<Module_Info>>());
      });

      test('deleteModule(id) Method In Database Should Return int ', () async {
        when(_mockDatabase.deleteModule("course1_module1"))
            .thenAnswer((realInvocation) => Future.value(1));

        expect(await _mockDatabase.deleteModule("course1_module1"), isA<int>());
      });

      test('updateModule(moduleInfo) Method In Database Should Return int ',
          () async {
        when(_mockDatabase.updateModule(moduleInfo))
            .thenAnswer((realInvocation) => Future.value(1));

        expect(await _mockDatabase.updateModule(moduleInfo), isA<int>());
      });
    });
  });
}
