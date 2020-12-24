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
    //Add Data To the Module Table
    _populateModuleTableFromApi();

    //Add Data To the Course Table
    _populateCourseTableFromApi();

    super.initState();
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
          print("Some Error Occured While Fetching Data in Splash Screen");
          print(err);
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => Courses_Home()));
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
