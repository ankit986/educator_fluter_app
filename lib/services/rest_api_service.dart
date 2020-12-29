import 'dart:convert';
import 'package:educator/Model/course_info.dart';
import 'package:educator/Model/module_info.dart';
import 'package:http/http.dart' as http;

//To get all modules through API(GET)
Future<ModuleInfoList> getAllModules() async {
  final url = 'https://dummy-api-employee.herokuapp.com/api/module';
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonCourse = jsonDecode(response.body);

    return ModuleInfoList.fromJson(jsonCourse);
  } else {
    throw Exception(
        'Error In file rest_api_service.dart  Error while Fetching All Courses');
  }
}

//To get all courses through API(GET)
Future<CourseInfoList> getAllCourses() async {
  final url = 'https://dummy-api-employee.herokuapp.com/api/course';
  final response = await http.get(url);

  if (response.statusCode == 200) {
    final jsonCourse = jsonDecode(response.body);
    return CourseInfoList.fromJson(jsonCourse);
  } else {
    throw Exception(
        'Error In file rest_api_service.dart  Error while Fetching All Courses');
  }
}

//To add modules through API(POST)
Future<ModuleInfoList> addModuleToServer(ModuleInfoList moduleInfo) async {
  final url = 'https://dummy-api-employee.herokuapp.com/api/module';

  var bodyJson = moduleInfo.toJson();

  final response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(bodyJson));

  if (response.statusCode == 200) {
    final jsonCourse = jsonDecode(response.body);

    return ModuleInfoList.fromJson(jsonCourse);
  } else {
    throw Exception(
        'Error In file rest_api_service.dart  Error while Posting All Modules');
  }
}

//To add course through API(POST)
Future<CourseInfoList> addCourseToServer(CourseInfoList courseInfo) async {
  final url = 'https://dummy-api-employee.herokuapp.com/api/course';
  var bodyJson = courseInfo.toJson();

  final response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(bodyJson));

  if (response.statusCode == 200) {
    final jsonCourse = jsonDecode(response.body);

    return CourseInfoList.fromJson(jsonCourse);
  } else {
    throw Exception(
        'Error In file rest_api_service.dart  Error while Posting All Modules');
  }
}

//To update module through API(PUT)
Future<int> updateModuleToServer(
    ModuleInfoList moduleInfo, String module_id) async {
  final url =
      'https://dummy-api-employee.herokuapp.com/api/module/${module_id}';

  var bodyJson = moduleInfo.toJson();

  final response = await http.put(
    url,
    body: jsonEncode(bodyJson),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    final jsonCourse = jsonDecode(response.body);
    print("JSON COURSE");
    print(response.body);
    return 1;
  } else {
    throw Exception(
        'Error In file rest_api_service.dart  Error while UPDATING Modules');
  }
}

//To update course through API(PUT)
Future<int> updateCourseToServer(
    CourseInfoList courseInfo, String course_id) async {
  final url =
      'https://dummy-api-employee.herokuapp.com/api/course/${course_id}';
  var bodyJson = courseInfo.toJson();

  final response = await http.put(
    url,
    body: jsonEncode(bodyJson),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
  );

  if (response.statusCode == 200) {
    final jsonCourse = jsonDecode(response.body);
    return 1;
  } else {
    throw Exception(
        'Error In file rest_api_service.dart  Error while Updating All Modules');
  }
}

//To delete course through API(DELETE)
Future<int> deleteCourseFromServer(String course_id) async {
  final url =
      'https://dummy-api-employee.herokuapp.com/api/course/${course_id}';
  final response = await http.delete(url);

  if (response.statusCode == 200) {
    final jsonCourse = jsonDecode(response.body);
    print(jsonCourse);
    return 1;
  } else {
    throw Exception(
        'Error In file rest_api_service.dart  Error while deleting course with course_id ${course_id}');
  }
}

//To delete module through API(DELETE)
Future<int> deleteModuleFromServer(String module_id) async {
  final url =
      'https://dummy-api-employee.herokuapp.com/api/module/${module_id}';
  final response = await http.delete(url);

  if (response.statusCode == 200) {
    final jsonModule = jsonDecode(response.body);
    print(jsonModule);
    return 1;
  } else {
    throw Exception(
        'Error In file rest_api_service.dart  Error while deleting module with module_id ${module_id}');
  }
}

//Helper Methods for API Because API returns a list of JSON objects and our CourseInfo model can parse a single JSON Object
class CourseInfoList {
  CourseInfoList({
    this.courses,
  });

  List<Course_Info> courses;

  factory CourseInfoList.fromJson(Map<String, dynamic> json) => CourseInfoList(
        courses: List<Course_Info>.from(
            json["courses"].map((x) => Course_Info.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "course": courses[0].toJson(),
      };
}

//Helper Methods for API Because API returns a list of JSON objects and our ModuleInfo model can parse a single JSON Object
class ModuleInfoList {
  ModuleInfoList({
    this.modules,
  });

  List<Module_Info> modules;

  factory ModuleInfoList.fromJson(Map<String, dynamic> json) => ModuleInfoList(
        modules: List<Module_Info>.from(
            json["modules"].map((x) => Module_Info.fromJson(x))),
      );

  Map<String, dynamic> toJson() => {
        "module": modules[0].toJson(),
      };
}
