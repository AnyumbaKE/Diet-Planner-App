part of 'custom_ing_bloc.dart';

abstract class CustomIngEvent {}

class AddAltMeasureCI extends CustomIngEvent {}

class ChangeAltMeasureNameCI extends CustomIngEvent {
  int index;
  String newName;

  ChangeAltMeasureNameCI(this.index, this.newName);
}

class ChangeAltMeasureValueCI extends CustomIngEvent {
  int index;
  String newValue;

  ChangeAltMeasureValueCI(this.index, this.newValue);
}

class ChangeNutrientValueCI extends CustomIngEvent {
  Nutrient nut;
  String value;

  ChangeNutrientValueCI(this.nut, this.value);
}

class ChangeNameCI extends CustomIngEvent {
  String name;

  ChangeNameCI(this.name);
}

class ChangeGramsCI extends CustomIngEvent {
  String value;
  ChangeGramsCI(this.value);
}

class NewImageCI extends CustomIngEvent {
  Uri? path;
  NewImageCI(this.path);
}

class OnSubmitCI extends CustomIngEvent {}
// class AddAltMeasureCI extends CustomIngEvent {}