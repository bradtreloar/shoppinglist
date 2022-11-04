class DuplicateIdException implements Exception {
  final String modelClass;
  final int id;

  const DuplicateIdException(this.modelClass, this.id);

  @override
  String toString() => '$modelClass already exists with ID: $id';
}
