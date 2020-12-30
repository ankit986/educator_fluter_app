import 'dart:async';

import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:educator/screens/Courses_Home_Screen.dart';
import 'package:educator/services/rest_api_service.dart';
import 'package:educator/sqlite/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class Splash_Screen extends StatefulWidget {
  static const routeName = '/splashScreen';

  @override
  _Splash_ScreenState createState() => _Splash_ScreenState();
}

class _Splash_ScreenState extends State<Splash_Screen> {
  bool isLoading = true;
  DbHelper _dbHelper = DbHelper();

  @override
  void initState() {
    loadDataFromApi();

    super.initState();
  }

  void loadDataFromApi() async {
    //Using Data Connection Checker Library For checking Availability of Internet
    var listener = DataConnectionChecker().onStatusChange.listen((status) {
      switch (status) {
        case DataConnectionStatus
            .connected: // If Internet Connection Is Available
          //Add Data To the Module Table
          _populateModuleTableFromApi();
          //Add Data To the Course Table
          _populateCourseTableFromApi();

          break;
        case DataConnectionStatus
            .disconnected: // If Internet Connection Is Not Available
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text('No Internet'),
              content: Text(
                  'Internet Is Not Connected You Will Not Receive Updated Data. '),
              actions: <Widget>[
                new FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Courses_Home()));
                  },
                )
              ],
            ),
          );

          break;
      }
    });

    // close listener after 30 seconds, so the program doesn't run forever
    await Future.delayed(Duration(seconds: 30));
    await listener.cancel();
  }

  void _populateCourseTableFromApi() {
    getAllCourses()
        .then((value) {
          //Getting Course Data through API
          for (var course in value.courses) {
            _dbHelper.insertCourse(course);
          }
        })
        .then((value) => {
              //When Data is added inside the Course Table Then Navigate to CourseHome
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (BuildContext context) => Courses_Home()))
            })
        .catchError((err) {
          showDialog(
            context: context,
            barrierDismissible: false,
            builder: (context) => AlertDialog(
              title: Text('Error'),
              content: Text('Error while receiving latest updates'),
              actions: <Widget>[
                new FlatButton(
                  child: Text('OK'),
                  onPressed: () {
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (BuildContext context) => Courses_Home()));
                  },
                )
              ],
            ),
          );

          print("Some Error Occured While Fetching Data in Splash Screen");
          print(err);
        });
  }

  void _populateModuleTableFromApi() {
    getAllModules().then((value) {
      //Fetching Module Data and adding to Local Database
      for (var module in value.modules) {
        _dbHelper.insertModule(module);
      }
    }).catchError((err) {
      print(err);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          gradient: LinearGradient(
            colors: <Color>[Color(0xFF6448FE), Color(0xFF5FC6FF)],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Text(
              'Starting...',
              style: GoogleFonts.nunito(
                  fontSize: 25,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}
