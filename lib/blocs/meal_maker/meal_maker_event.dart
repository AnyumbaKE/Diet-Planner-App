part of 'meal_maker_bloc.dart';

@immutable
abstract class MealMakerEvent {}

class ChangePhoto extends MealMakerEvent {
  final Uri? uri;
  ChangePhoto(this.uri);
}

class ChangeName extends MealMakerEvent {
  final String name;
  ChangeName(this.name);
}

class ChangeServings extends MealMakerEvent {
  final String serving;
  ChangeServings(this.serving);
}

class AddMC extends MealMakerEvent {
  final MealComponent mc;

  AddMC(this.mc);
}

class DeleteMC extends MealMakerEvent {
  final MealComponent mc;
  DeleteMC(this.mc);
}

class UpdateGramsMC extends MealMakerEvent {
  final MealComponent mc;
  final num grams;
  final String serving;

  UpdateGramsMC(this.mc, this.grams, this.serving);
}

class EditMC extends MealMakerEvent {
  final int index;
  final MealComponent mc;
  final MealComponentFactory factory;
  final App app;

  EditMC({
    required this.index,
    required this.mc,
    required this.factory,
    required this.app,
  });
}

class ReorderMC extends MealMakerEvent {
  final int oldIndex;
  final int newIndex;
  ReorderMC(this.oldIndex, this.newIndex);
}

class ToggleSub extends MealMakerEvent {
  final bool toggle;

  ToggleSub(this.toggle);
}

class AltMeasureName extends MealMakerEvent {
  final String name;
  final int index;

  AltMeasureName(this.name, this.index);
}

class AltMeasureValue extends MealMakerEvent {
  final String val;
  final int index;

  AltMeasureValue(this.val, this.index);
}

class AddAltMeasure extends MealMakerEvent {}

class SubmitMM extends MealMakerEvent {}

class UpdateNotes extends MealMakerEvent {
  final String notes;
  UpdateNotes(this.notes);
}

class ChangeNutDisplayEvent extends MealMakerEvent {}
// class ChangePhoto extends MealMakerEvent{}
// class ChangePhoto extends MealMakerEvent{}