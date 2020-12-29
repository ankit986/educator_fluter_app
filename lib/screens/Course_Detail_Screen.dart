import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:educator/screens/Module_Details_Screen.dart';
import 'package:educator/screens/New_Course_Screen.dart';

import 'package:educator/services/rest_api_service.dart';

import 'package:educator/Model/course_info.dart';
import 'package:educator/sqlite/db_helper.dart';
import 'package:educator/Model/module_info.dart';

import 'Courses_Home_Screen.dart';

final DbHelper _moduleHelper = DbHelper();
final DbHelper _courseHelper = DbHelper();

class Course_Detail extends StatefulWidget {
  static const routeName = '/courseDetails';

  final String course_id;

  Course_Detail({Key key, @required this.course_id}) : super(key: key);

  @override
  _Course_DetailState createState() => _Course_DetailState();
}

class _Course_DetailState extends State<Course_Detail> {
  Future<List<Module_Info>> _module;
  Future<List<Course_Info>> _course;
  String course_id;
  String courseName = "";
  String numberOfModules = "0";
  Stream<List<Module_Info>> _moduleStream;
  Stream<List<Course_Info>> _courseStream;

  @override
  void initState() {
    _fetchInitialData();
    super.initState();
  }

  //To Fetch Initial Data :- Course_Name, numberOfModules and moduleDetails
  void _fetchInitialData() {
    course_id = widget.course_id;

    if (course_id != null) {
      //Getting modules from local server
      _module = _moduleHelper.getModulesBycourse_id(course_id);

      _module.then((value) {
        setState(() {
          numberOfModules = value.length.toString();
        });
      }).catchError(((onError) {
        print(onError);
      }));

      //Getting modules from local server
      _course = _moduleHelper.getCourseBycourse_id(course_id);

      _course.then((value) {
        setState(() {
          courseName = value[0].course_title;
        });

        //Convert Future Builder (received by calling getModulesBycourse_id) to StreamBuilder
        _moduleStream = Stream.fromFuture(_module);
      });

      _courseStream = Stream.fromFuture(_course);
    }
  }

  //To Refresh the Screen when Navigate Back
  void refreshPage() {
    _fetchInitialData();
  }

  //To Delete the Course
  void _deleteCourse() {
    if (widget.course_id != null) {
      deleteCourseFromServer(widget.course_id);
      _courseHelper.deleteCourse(widget.course_id);
    }

    Navigator.pushReplacementNamed(context, Courses_Home.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: 25),
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF6448FE), Color(0xFF5FC6FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 15.0, left: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          //Navigate Back to Course Home Screen

                          Navigator.of(context, rootNavigator: true)
                              .pop((context));
                        },
                        child: Image.asset(
                          'assets/images/back.png',
                          width: 40,
                        ),
                      ),
                      Spacer(),
                      PopupMenuButton(
                        child: Image.asset(
                          'assets/images/popupmenubuttonn.png',
                          width: 20,
                        ),
                        itemBuilder: (context) => <PopupMenuEntry<String>>[
                          PopupMenuItem<String>(
                            child: InkWell(
                              onTap: () async {
                                await _asyncConfirmDialog(context);
                              },
                              child: Text('Delete This Course'),
                            ),
                          ),
                          PopupMenuItem<String>(
                            child: InkWell(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        New_Course(course_id: course_id),
                                  ),
                                ).then((value) {
                                  refreshPage();
                                });
                              },
                              child: Text('Edit This Course'),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        width: 20,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(top: 50, left: 15, bottom: 20),
                  child: Column(
                    children: [
                      Container(
                        child: Center(
                          child: Text(
                            courseName.toUpperCase(),
                            style: GoogleFonts.nunito(
                              fontSize: courseName.length > 16 ? 20 : 30,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              shadows: <Shadow>[
                                Shadow(
                                  offset: Offset(10.0, 10.0),
                                  blurRadius: 8.0,
                                  color: Color.fromARGB(125, 0, 0, 255),
                                ),
                              ],
                            ),
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 16,
                      ),
                      Text(
                        '${numberOfModules}'.toUpperCase(),
                        style: GoogleFonts.nunito(
                          fontSize: 20,
                          color: Colors.white,
                          shadows: <Shadow>[
                            Shadow(
                              offset: Offset(10.0, 10.0),
                              blurRadius: 8.0,
                              color: Color.fromARGB(255, 0, 0, 0),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                padding: EdgeInsets.only(top: 20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Colors.white,
                ),
                child: SingleChildScrollView(
                  child: CourseLists(
                    refreshPage: refreshPage,
                    module: _moduleStream,
                  ),
                ),
              ),
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        label: Text('Add New Module'),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => Module_Details(course_id: course_id)),
          ).then((value) {
            refreshPage();
          });
        },
      ),
    );
  }

  Future<ConfirmAction> _asyncConfirmDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete This Course?'),
          content: const Text('This will delete the course permanently.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            FlatButton(
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Accept);
                Navigator.pop(context);
                _deleteCourse();
              },
            )
          ],
        );
      },
    );
  }
}

// Widget To Create List of Courses
class CourseLists extends StatefulWidget {
  Stream<List<Module_Info>> module;
  final refreshPage;
  CourseLists({Key key, this.refreshPage, this.module}) : super(key: key);

  @override
  _CourseListsState createState() => _CourseListsState();
}

class _CourseListsState extends State<CourseLists> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
      stream: widget.module,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          return SingleChildScrollView(
            child: ListView.builder(
                physics: const AlwaysScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: snapshot.data.length,
                itemBuilder: (context, index) {
                  String title = snapshot.data[index].module_name;
                  String module_id = snapshot.data[index].module_id;
                  String course_id = snapshot.data[index].course_id;
                  return Content(
                      refreshPage: widget.refreshPage,
                      module_id: module_id,
                      course_id: course_id,
                      number: (index + 1).toString(),
                      title: title);
                }),
          );
        } else {
          return Text('Loading');
        }
      },
    );
  }
}

// Widget : Item of ListView
class Content extends StatelessWidget {
  final String number;
  final String title;
  final String module_id;
  final String course_id;
  final refreshPage;

  const Content(
      {Key key,
      this.refreshPage,
      this.module_id,
      this.title,
      this.course_id,
      this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 15),
      child: InkWell(
        onTap: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    Module_Details(module_id: module_id, course_id: course_id)),
          ).then((value) {
            refreshPage();
          });
        },
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                  width: 20,
                ),
                Text(
                  number,
                  style: GoogleFonts.nunito(
                      fontSize: 34, fontWeight: FontWeight.bold),
                ),
                SizedBox(
                  width: 20,
                ),
                FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    title.length < 30 ? title : title.substring(0, 21) + '...',
                    style: GoogleFonts.nunito(
                      fontSize: 25,
                    ),
                  ),
                ),
                Spacer(),
                SizedBox(
                  width: 10,
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15.0),
              child: Container(
                height: 1.0,
                width: double.infinity,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

enum ConfirmAction { Cancel, Accept }
