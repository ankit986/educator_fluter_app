import 'dart:async';

import 'package:educator/Model/course_info.dart';
import 'package:educator/bloc/course_home_bloc.dart';
import 'package:flutter/cupertino.dart';

class DataProvider extends InheritedWidget {
  final CoursesBloc coursesBloc = CoursesBloc();
  final Widget child;
  DataProvider({this.child}) : super(child: child);

  static DataProvider of(BuildContext context) {
    return context.inheritFromWidgetOfExactType(DataProvider);
  }

  @override
  bool updateShouldNotify(InheritedWidget oldWidget) => true;

  Stream<List<Course_Info>> get coursesStream => coursesBloc.coursesStream;
  StreamSink<List<Course_Info>> get coursesSink => coursesBloc.coursesSink;
}
