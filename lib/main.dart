import 'package:educator/screens/Course_Detail_Screen.dart';
import 'package:educator/screens/SplashScreen.dart';
import 'package:educator/screens/Courses_Home_Screen.dart';
import 'package:educator/screens/Module_Details_Screen.dart';
import 'package:educator/screens/New_Course_Screen.dart';
import 'package:educator/services/rest_api_service.dart';
import 'package:educator/sqlite/course_info.dart';
import 'package:educator/sqlite/db_helper.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  // This widget is the root of the application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  DbHelper _dbHelper = DbHelper();
  Future<List<Course_Info>> _dbs;
  @override
  void initState() {
    //Initialize Local Database(SQLite)
    _initilizeTheDatabase();

    super.initState();
  }

  void _initilizeTheDatabase() {
    _dbHelper.initializeDatabase().then((value) {
      print(value);
    }).then((value) {
      _dbs = _dbHelper.getCourses();
      _dbs.then((value) => {print(value)});
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      // initialRoute: Courses_Home.routeName,
      initialRoute: Splash_Screen.routeName,
      routes: {
        Courses_Home.routeName: (context) => Courses_Home(),
        Module_Details.routeName: (context) => Module_Details(),
        Course_Detail.routeName: (context) => Course_Detail(),
        New_Course.routeName: (context) => New_Course(),
        Splash_Screen.routeName: (context) => Splash_Screen(),
      },
      home: Courses_Home(),
    );
  }
}
