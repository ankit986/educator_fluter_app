import '../Model/course_info.dart';
import 'db_helper.dart';

class CoursesRepository {
  final _courseHelper = DbHelper();

  Future getCoursesFromRepo() => _courseHelper.getCourses();

  Future createCourseFromRepo(Course_Info courseInfo) =>
      _courseHelper.insertCourse(courseInfo);

  Future updateCourseFromRepo(Course_Info courseInfo) =>
      _courseHelper.updateCourse(courseInfo);

  Future getCoursesByCourseIDFromRepo(String id) =>
      _courseHelper.getCourseBycourse_id(id);

  Future deleteCourseFromRepo(String id) => _courseHelper.deleteCourse(id);
}
