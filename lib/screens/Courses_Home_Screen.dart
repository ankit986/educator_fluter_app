import 'package:educator/Model/CourseProvider.dart';
import 'package:educator/bloc/course_home_bloc.dart';
import 'package:flutter/material.dart';
import 'dart:ui' as ui;
import 'package:google_fonts/google_fonts.dart';

import 'package:educator/screens/New_Course_Screen.dart';
import 'package:educator/screens/Course_Detail_Screen.dart';

import 'package:educator/services/rest_api_service.dart';
import 'package:educator/sqlite/db_helper.dart';
import 'package:educator/Model/course_info.dart';
import 'package:provider/provider.dart';

class Courses_Home extends StatefulWidget {
  static const routeName = '/coursesHome';

  @override
  _Courses_HomeState createState() => _Courses_HomeState();
}

class _Courses_HomeState extends State<Courses_Home> {
  Future<List<Course_Info>> _courses;
  Stream<List<Course_Info>> _coursesStream;
  DbHelper _courseHelper = DbHelper();

  final CoursesBloc coursesBloc = CoursesBloc();
  // _create/update course stream
  void _createCoursesStream() {
    print("printing in courses home screen");
    _courses = _courseHelper.getCourses();
    setState(() {
      //Convert  Future<List<Course_Info>>  into  Stream<List<Course_Info>>
      //Because we want to rebuild the widget
      _coursesStream = Stream.fromFuture(_courses);
    });
  }

  @override
  void initState() {
    // COMMENTING THIS WHILE TRYING USING BLOC
    _createCoursesStream();
    _courses = _courseHelper.getCourses();
    _coursesStream = Stream.fromFuture(_courses);
    super.initState();
  }

  //To refresh page on navigating back
  void refreshPage() {
    _createCoursesStream();
  }

  @override
  Widget build(BuildContext context) {
    //TODO Delete following two lines
    var providerCourse = DataProvider.of(context);
    print(providerCourse);

    return Scaffold(
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.only(bottom: 26),
            decoration: BoxDecoration(
                color: Colors.indigo,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(36),
                  bottomLeft: Radius.circular(36),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 10),
                    color: Colors.blue.withOpacity(0.6),
                    blurRadius: 50,
                  ),
                ]),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 50, right: 20),
                  child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Image.asset(
                          'assets/images/user.png',
                          width: 50,
                          height: 50,
                        )
                      ]),
                ),
                SizedBox(
                  height: 20,
                ),
                Align(
                  alignment: Alignment.centerRight,
                  child: Container(
                    padding: EdgeInsets.only(right: 20),
                    child: Text(
                      "Hey, User",
                      style: GoogleFonts.nunito(
                        fontSize: 40,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Align(
            alignment: Alignment.centerRight,
            child: Container(
              padding: EdgeInsets.only(right: 10, top: 20, bottom: 10),
              child: Text(
                "Courses You Created ",
                style: GoogleFonts.nunito(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  foreground: Paint()
                    ..shader = ui.Gradient.linear(
                      const Offset(0, 20),
                      const Offset(150, 10),
                      <Color>[
                        Colors.orange[100],
                        Colors.blue,
                      ],
                    ),
                ),
              ),
            ),
          ),
          Courses_Grid(
            courses: _courses,

            // coursesStream: providerCourse.coursesStream,
            coursesStream: _coursesStream,
            refreshPage: refreshPage,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          await Navigator.pushNamed(context, New_Course.routeName);
        },
        label: Text('Create Course'),
      ),
    );
  }
}

class Courses_Grid extends StatelessWidget {
  Future<List<Course_Info>> courses;
  Stream<List<Course_Info>> coursesStream;

  final refreshPage;

  Courses_Grid({Key key, this.courses, this.coursesStream, this.refreshPage})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: StreamBuilder(
        initialData: [],
        stream: coursesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Container(
              child: GridView.count(
                  crossAxisCount: 2,
                  padding: EdgeInsets.all(0),
                  children: snapshot.data
                      .map<Widget>(
                        (value) => CourseTile(
                            course_id: value.course_id,
                            course_name: value.course_title,
                            created_at: value.created_at,
                            refreshPage: refreshPage),
                      )
                      .toList()),
            );
          } else if (snapshot.hasError) {
            return Center(child: Text('Error in Loading Course'));
          } else
            return Center(child: Text('Loading'));
        },
      ),
    );
  }
}

class CourseTile extends StatelessWidget {
  String course_name;
  String course_id;
  DateTime created_at;
  final refreshPage;

  CourseTile(
      {Key key,
      this.refreshPage,
      this.course_id,
      this.course_name,
      this.created_at})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => Course_Detail(course_id: course_id)))
            .then(
          (value) {
            refreshPage();
          },
        );
      },
      child: Container(
        margin: EdgeInsets.all(10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF6448FE), Color(0xFF5FC6FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
          boxShadow: [
            BoxShadow(
              color: <Color>[Color(0xFF6448FE), Color(0xFF5FC6FF)]
                  .last
                  .withOpacity(0.4),
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(4, 4),
            ),
          ],
        ),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              '$course_name',
              style: GoogleFonts.nunito(
                  fontSize: 30,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Text(
              '${created_at.toString()}'.split(' ')[0],
              style: GoogleFonts.nunito(fontSize: 15, color: Colors.white),
            ),
          ),
        ]),
      ),
    );
  }
}
