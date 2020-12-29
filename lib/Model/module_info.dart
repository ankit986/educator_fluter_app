// Module Model
class Module_Info {
  String course_id;
  String module_id;
  int moduleNumber = 1;
  String module_name;
  String module_description;

  Module_Info(
      {this.course_id,
      this.module_id,
      this.moduleNumber,
      this.module_name,
      this.module_description});

  factory Module_Info.fromJson(Map<String, dynamic> json) => Module_Info(
        course_id: json["course_id"].runtimeType != String
            ? json["course_id"].toString()
            : json["course_id"],
        module_id: json["module_id"].runtimeType != String
            ? json["module_id"].toString()
            : json["module_id"],
        moduleNumber: 1,
        module_name: json["module_name"].runtimeType != String
            ? json["module_name"].toString()
            : json["module_name"],
        module_description: json["module_description"].runtimeType != String
            ? json["module_description"].toString()
            : json["module_description"],
      );

  Map<String, dynamic> toJson() => {
        "course_id": course_id,
        "module_id": module_id,
        // "moduleNumber": moduleNumber,
        "module_name": module_name,
        "module_description": module_description,
      };
}
