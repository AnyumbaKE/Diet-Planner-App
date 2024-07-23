part of 'index_bloc.dart';

@immutable
abstract class IndexEvent {}

class AddDiet extends IndexEvent {
  final String name;
  AddDiet(this.name);
}

class DuplicateDiet extends IndexEvent {
  final Diet diet;
  DuplicateDiet(this.diet);
}

class RenameDiet extends IndexEvent {
  final Diet diet;
  final String newName;
  RenameDiet({required this.diet, required this.newName});
}

class DeleteDiet extends IndexEvent {
  final Diet diet;
  DeleteDiet(this.diet);
}

class ReorderDiet extends IndexEvent {
  final int oldIndex;
  final int newIndex;

  ReorderDiet({
    required this.oldIndex,
    required this.newIndex,
  });
}
