abstract class Model {
  final int id;

  Model({required this.id});

  Model.fromMap(Map<String, dynamic> map) : id = map['id'];

  Map<String, dynamic> toMap();

  @override
  String toString() => '$runtimeType{$id}';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Model && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
