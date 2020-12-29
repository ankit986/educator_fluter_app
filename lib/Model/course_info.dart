// Course Model
class Course_Info {
  String course_id;
  String course_title;
  DateTime created_at;
  double course_price;

  Course_Info(
      {this.course_id, this.course_title, this.created_at, this.course_price});

  factory Course_Info.fromJson(Map<String, dynamic> json) => Course_Info(
        course_id: json["course_id"].runtimeType != String
            ? json["course_id"].toString()
            : json["course_id"],
        course_title: json["course_title"].runtimeType != String
            ? json["course_title"].toString()
            : json["course_title"],
        created_at: json["created_at"] == null
            ? null
            : DateTime.parse(json["created_at"]),
        course_price: json["course_price"].runtimeType != double
            ? double.parse(json["course_price"].toString())
            : json["course_price"],
      );

  Map<String, dynamic> toJson() => {
        "course_id": course_id,
        "course_title": course_title,
        "created_at": created_at.toIso8601String(),
        "course_price": course_price,
      };
}
