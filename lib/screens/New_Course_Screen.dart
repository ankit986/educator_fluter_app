import 'package:educator/bloc/course_home_bloc.dart';
import 'package:flutter/material.dart';

import 'package:educator/screens/Courses_Home_Screen.dart';

import 'package:educator/services/rest_api_service.dart';

import 'package:educator/sqlite/db_helper.dart';
import 'package:educator/Model/course_info.dart';

class New_Course extends StatefulWidget {
  static const routeName = '/newCourse';

  String course_id;

  New_Course({Key key, this.course_id}) : super(key: key);

  @override
  _New_CourseState createState() => _New_CourseState();
}

class _New_CourseState extends State<New_Course> {
  final _formKey = GlobalKey<FormState>();
  final DbHelper _DbHelper = DbHelper();
  Future<List<Course_Info>> _courses;

  final CoursesBloc coursesBloc = CoursesBloc();

  final _course_titleController = TextEditingController();
  final _course_priceController = TextEditingController();
  DateTime _created_at = DateTime.now();

  @override
  void initState() {
    //If we want to edit the course details
    populateFormFields();

    super.initState();
  }

  populateFormFields() {
    _courses = _DbHelper.getCourses();

    //If course_id is already available then populate the Form Fields
    if (widget.course_id != null) {
      //Fetching List of Courses from Local Database
      Future<List<Course_Info>> _currentCourses =
          _DbHelper.getCourseBycourse_id(widget.course_id);
      _currentCourses.then((value) {
        Course_Info oldCourse = value[0];

        //Setting the field value to course whose course id is received
        _course_titleController.text = oldCourse.course_title;
        _course_priceController.text = oldCourse.course_price.toString();
        setState(() {
          _created_at = oldCourse.created_at;
        });
      });
    }
  }

  //To Save Course in Database and through API
  void _saveCourse() {
    double _course_price = double.parse(_course_priceController.text);
    String _course_title = _course_titleController.text;

    String id = _course_title
            .replaceAll(new RegExp(r"[^\s\w ]"), '')
            .replaceAll(' ', '') +
        "_" +
        DateTime.now().microsecondsSinceEpoch.toString();

    var courseInfo = Course_Info(
        course_id: id,
        course_title: _course_title,
        created_at: _created_at,
        course_price: _course_price);

    //Insert Course into Local Database
    // _DbHelper.insertCourse(courseInfo);
    coursesBloc.addCoursesBloc(courseInfo);

    CourseInfoList courseInfoList = new CourseInfoList(courses: [courseInfo]);

    //Add Course through API Post request
    addCourseToServer(courseInfoList).then((value) {
      print("COURSE ADDED FROM SCREEN");
      print(value);
    }).catchError((onError) {
      print("Error While Adding Course To The Server");
      print(onError);
    });

    //Navigate To Course Home
    // Navigator.pop(context);
    Navigator.pushReplacementNamed(context, Courses_Home.routeName);
  }

  //To Update Course in Database and through API
  void _updateCourse() {
    double _course_price = double.parse(_course_priceController.text);
    String _course_title = _course_titleController.text;

    var courseInfo = Course_Info(
        course_id: widget.course_id,
        course_title: _course_title,
        created_at: _created_at,
        course_price: _course_price);

    //Insert Course into Local Database
    _DbHelper.updateCourse(courseInfo);

    CourseInfoList courseInfoList = new CourseInfoList(courses: [courseInfo]);

    //Add Course To Server using API Post request
    updateCourseToServer(courseInfoList, widget.course_id).then((value) {
      print("COURSE UPDATED FROM SCREEN");
      print(value);
    }).catchError((error) {
      print("Error While Updating The Screen");
    });

    //Navigate To Course Home
    Navigator.pop(context);
    // Navigator.pushReplacementNamed(context, Courses_Home.routeName);
  }

  //Date Picker
  _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
      context: context,
      initialDate: _created_at,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
      initialEntryMode: DatePickerEntryMode.input,
    );
    if (picked != null && picked != _created_at) {
      setState(() {
        _created_at = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Course'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  TextFormField(
                    controller: _course_titleController,
                    validator: Validator.validateCourseTitle,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Course Title',
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    validator: Validator.validateCoursePrice,
                    controller: _course_priceController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      labelText: 'Course Price(in Rs.)',
                    ),
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        'Course Creation Date',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 25),
                      ),
                      Text(
                        "${_created_at.toLocal()}"
                                .split(' ')[0] ?? // To get date from datetime
                            'Course Creation Date ',
                        style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                            fontSize: 21),
                      ),
                    ],
                  ),
                  RaisedButton(
                    onPressed: () => _selectDate(context),
                    child: Text(
                      'Select Another date',
                      style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    color: Colors.greenAccent,
                  ),
                  SizedBox(
                    height: 30.0,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ButtonBar(
                        children: [
                          widget.course_id ==
                                  null // If course Id is not available then save, otherwise update
                              ? RaisedButton(
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      await _confirmCreateDialog(context);
                                    }
                                  },
                                  color: Color(0xFF6200EE),
                                  child: Text('Create'),
                                )
                              : RaisedButton(
                                  textColor: Colors.white,
                                  onPressed: () async {
                                    if (_formKey.currentState.validate()) {
                                      await _confirmUpdateDialog(context);
                                    }
                                  },
                                  color: Color(0xFF6200EE),
                                  child: Text('Update'),
                                ),
                          RaisedButton(
                            textColor: Colors.white,
                            onPressed: () async {
                              if (_formKey.currentState.validate()) {
                                await _alertDialogCancel(context);
                              }
                            },
                            color: Color(0xFF6200EE),
                            child: Text('Cancel'),
                          ),
                        ],
                      )
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<ConfirmAction> _confirmCreateDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Create This Course?'),
          content: const Text('This will create the course from your device.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            FlatButton(
              child: const Text('Create'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Accept);
                _saveCourse();
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _confirmUpdateDialog(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update This Course?'),
          content: const Text('This will update the course from your device.'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            ),
            FlatButton(
              child: const Text('Update'),
              onPressed: () {
                Navigator.of(context).pop(ConfirmAction.Accept);
                _updateCourse();
              },
            )
          ],
        );
      },
    );
  }

  Future<ConfirmAction> _alertDialogCancel(BuildContext context) async {
    return showDialog<ConfirmAction>(
      context: context,
      barrierDismissible: false, // user must tap button for close dialog!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Cancel?'),
          actions: <Widget>[
            FlatButton(
              child: const Text('Yes'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: const Text('No'),
              onPressed: () {
                // Navigator.of(context).pop(ConfirmAction.Accept);
                Navigator.of(context).pop(ConfirmAction.Cancel);
              },
            )
          ],
        );
      },
    );
  }
}

//Type for Dialog Box
enum ConfirmAction { Cancel, Accept }

//To Validate the Form For Adding Course
class Validator {
  static String validateCoursePrice(String value) {
    if (value.isEmpty) {
      return 'Please Enter Course Price';
    }
    if (!value.contains(new RegExp(r'^[0-9]+(?:\.\d+)?$'))) {
      return 'Please Enter Number only';
    }
    return null;
  }

  static String validateCourseTitle(String value) {
    if (value.isEmpty) {
      return 'Please Enter Course Title';
    }
    return null;
  }
}
