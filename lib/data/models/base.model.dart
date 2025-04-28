abstract class BaseModel {
  String get id;

  DateTime get updatedAt;

  BaseModel copyWith({DateTime updatedAt});
}
