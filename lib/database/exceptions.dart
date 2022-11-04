class DuplicateIdException implements Exception {
  final String modelClass;
  final int id;

  const DuplicateIdException(this.modelClass, this.id);

  @override
  String toString() => '$modelClass already exists with ID: $id';
}

class IdNotFoundException implements Exception {
  final String modelClass;
  final int id;

  const IdNotFoundException(this.modelClass, this.id);

  @override
  String toString() => '$modelClass not found with ID: $id';
}

class NullIdException implements Exception {
  final String modelClass;

  const NullIdException(this.modelClass);

  @override
  String toString() => '$modelClass has null ID';
}
