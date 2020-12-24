import 'dart:async';

import 'package:educator/bloc/bloc.dart';
import 'package:educator/sqlite/course_info.dart';

class CoursesBloc implements Bloc {
  final coursesController = StreamController<List<Course_Info>>();

  Stream<List<Course_Info>> get coursesStream => coursesController.stream;
  StreamSink<List<Course_Info>> get coursesSink => coursesController.sink;

  final eventController = StreamController<List<Course_Info>>();

  StreamSink<List<Course_Info>> get eventSink => eventController.sink;
  Stream<List<Course_Info>> get eventStream => eventController.stream;

  CoursesBloc() {
    eventStream.listen((event) {
      print(event);
    });
  }

  void dispose() {
    coursesController.close();
    eventController.close();
  }
}
