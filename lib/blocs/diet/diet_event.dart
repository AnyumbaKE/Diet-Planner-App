part of 'diet_bloc.dart';

@immutable
abstract class DietEvent {}

class RefreshDietEvent extends DietEvent {}

void refreshDiet(BuildContext context) {
  context.read<DietBloc>().add(RefreshDietEvent());
}

class AddDay extends DietEvent {}

class AddMealToDay extends DietEvent {
  final Meal meal;
  final Day day;

  AddMealToDay(this.meal, this.day);
}

class EditMealInDay extends DietEvent {
  final int index;
  final Day day;
  final MealComponent mc;
  final MealComponentFactory factory;
  final App app;

  EditMealInDay(
      {required this.index,
      required this.mc,
      required this.factory,
      required this.app,
      required this.day});
}

class AddIngredientToDay extends DietEvent {
  final Ingredient ingredient;
  final Day day;

  AddIngredientToDay(this.ingredient, this.day);
}

class DuplicateMealInDay extends DietEvent {
  final MealComponent meal;
  final Day day;
  DuplicateMealInDay(this.meal, this.day);
}

class MealUpdateGrams extends DietEvent {
  final int index;
  final Day day;
  final String serving;
  final num value;

  MealUpdateGrams({
    required this.index,
    required this.day,
    required this.serving,
    required this.value,
  });
}

class DeleteMealFromDay extends DietEvent {
  final int index;
  final Day day;

  DeleteMealFromDay(this.index, this.day);
}

class ReorderMealInDay extends DietEvent {
  final Day day;
  final int new_;
  final int old;

  ReorderMealInDay({
    required this.day,
    required this.new_,
    required this.old,
  });
}

class ReorderDay extends DietEvent {
  final int old;
  final int new_;

  ReorderDay(this.old, this.new_);
}

class DuplicateDay extends DietEvent {
  final int dayIndex;

  DuplicateDay(this.dayIndex);
  factory DuplicateDay.fromDay(Diet diet, Day day) =>
      DuplicateDay(diet.days.indexOf(day));
}

class DeleteDay extends DietEvent {
  final Day day;

  DeleteDay(this.day);
}
