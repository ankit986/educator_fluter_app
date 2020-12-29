import 'package:sqflite/sqflite.dart';
import 'package:sqflite/sqlite_api.dart';
import 'package:flutter/widgets.dart';
import 'package:path/path.dart';

import '../Model/course_info.dart';
import '../Model/module_info.dart';

final String tableCourse = 'courses';
final String tableModule = 'modules';
final String course_id = 'course_id';
final String module_id = 'module_id';
final String course_title = 'title';
final String created_at = 'created_at';
final String course_price = 'course_price';

class DbHelper {
  static Database _database;
  static DbHelper _courseHelper;

  DbHelper._createInstance();

  factory DbHelper() {
    if (_courseHelper == null) {
      _courseHelper = DbHelper._createInstance();
    }
    return _courseHelper;
  }

  Future<Database> get database async {
    if (_database == null) {
      _database = await initializeDatabase();
    }
    return _database;
  }

  //Initialise the Database
  Future<Database> initializeDatabase() async {
    WidgetsFlutterBinding.ensureInitialized();
    var path = join(await getDatabasesPath(), "educator.db");

    final database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
            create table courses (
            course_id text primary key  ,
            course_title text not null,
            created_at datetime ,
            course_price real);
          ''');
        db.execute('''
            create table modules (
            course_id text   ,
            module_id text primary key ,
            module_name text not null,
            module_description String);
          ''');
      },
    );
    return database;
  }

  //For Courses Table
  Future insertCourse(Course_Info courseInfo) async {
    var db = await database;
    print(courseInfo.toJson());
    var result = await db.insert(
      tableCourse,
      courseInfo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    return result;
  }

  Future<List<Course_Info>> getCourses() async {
    List<Course_Info> _courses = [];
    final Database db = await database;

    final List<Map<String, dynamic>> result = await db.query(tableCourse);
    result.forEach((element) {
      var courseInfo = Course_Info.fromJson(element);

      print(element);
      _courses.add(courseInfo);
    });

    return _courses;
  }

  Future<List<Course_Info>> getCourseBycourse_id(String id) async {
    List<Course_Info> _courses = [];
    final Database db = await database;

    final List<Map<String, dynamic>> result =
        await db.query(tableCourse, where: '$course_id = ?', whereArgs: [id]);

    result.forEach((element) {
      var courseInfo = Course_Info.fromJson(element);
      _courses.add(courseInfo);
    });

    return _courses;
  }

  Future<int> deleteCourse(String id) async {
    final Database db = await database;

    return await db
        .delete(tableCourse, where: '$course_id = ?', whereArgs: [id]);
  }

  Future<int> updateCourse(Course_Info courseInfo) async {
    var db = await database;

    String updateID = courseInfo.course_id;

    print("UPDATING COURSE IN DB");
    print(updateID);
    var result = await db.update(tableCourse, courseInfo.toJson(),
        where: '$course_id = ?', whereArgs: [updateID]);

    return result;
  }

  //For Modules Table
  Future insertModule(Module_Info moduleInfo) async {
    var db = await database;
    print(moduleInfo.toJson());
    var result = await db.insert(
      tableModule,
      moduleInfo.toJson(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Module_Info>> getModules() async {
    List<Module_Info> _modules = [];
    final Database db = await database;

    final List<Map<String, dynamic>> result = await db.query(tableModule);
    result.forEach((element) {
      var courseInfo = Module_Info.fromJson(element);
      _modules.add(courseInfo);
    });

    return _modules;
  }

  Future<List<Module_Info>> getModulesBycourse_id(String id) async {
    List<Module_Info> _modules = [];
    final Database db = await database;

    final List<Map<String, dynamic>> result =
        await db.query(tableModule, where: '$course_id = ?', whereArgs: [id]);

    result.forEach((element) {
      var courseInfo = Module_Info.fromJson(element);

      _modules.add(courseInfo);
    });

    return _modules;
  }

  Future<List<Module_Info>> getModulesBymodule_id(String id) async {
    List<Module_Info> _modules = [];
    final Database db = await database;

    final List<Map<String, dynamic>> result =
        await db.query(tableModule, where: '$module_id = ?', whereArgs: [id]);
    result.forEach((element) {
      var courseInfo = Module_Info.fromJson(element);
      _modules.add(courseInfo);
    });

    return _modules;
  }

  Future<int> deleteModule(String id) async {
    final Database db = await database;

    return await db
        .delete(tableModule, where: '$module_id = ?', whereArgs: [id]);
  }

  Future<int> updateModule(Module_Info moduleInfo) async {
    var db = await database;

    String updateID = moduleInfo.module_id;
    var result = await db.update(tableModule, moduleInfo.toJson(),
        where: '$module_id = ?', whereArgs: [updateID]);

    return result;
  }
}
