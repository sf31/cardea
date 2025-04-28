abstract class BaseEntity {
  String get id;

  DateTime get updatedAt;

  BaseEntity copyWith({DateTime updatedAt});
}
