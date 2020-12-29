import 'dart:async';

import 'package:educator/bloc/bloc.dart';

import 'package:educator/Model/course_info.dart';
import 'package:educator/sqlite/courses_repository.dart';
import 'package:flutter/cupertino.dart';

class CoursesBloc {
  final _coursesRepository = new CoursesRepository();

  final coursesController = StreamController<List<Course_Info>>.broadcast();

  Stream<List<Course_Info>> get coursesStream => coursesController.stream;
  StreamSink<List<Course_Info>> get coursesSink => coursesController.sink;

  final eventController = StreamController<List<Course_Info>>();

  StreamSink<List<Course_Info>> get eventSink => eventController.sink;
  Stream<List<Course_Info>> get eventStream =>
      eventController.stream.asBroadcastStream();

  CoursesBloc() {
    getCoursesBloc();
  }

  getCoursesBloc() async {
    coursesSink.add(await _coursesRepository.getCoursesFromRepo());
  }

  getCoursesByCourseIdBloc(String id) async {
    coursesSink.add(await _coursesRepository.getCoursesByCourseIDFromRepo(id));
  }

  addCoursesBloc(Course_Info courseInfo) async {
    await _coursesRepository.createCourseFromRepo(courseInfo);
    getCoursesBloc();
  }

  updateCourseBloc(Course_Info courseInfo) async {
    await _coursesRepository.updateCourseFromRepo(courseInfo);
  }

  deleteCourseBloc(String id) async {
    await _coursesRepository.deleteCourseFromRepo(id);
  }

  void dispose() {
    coursesController.close();
    eventController.close();
  }
}
