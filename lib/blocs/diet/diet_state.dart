part of 'diet_bloc.dart';

@immutable
class DietState {
  final Diet diet;
  const DietState(this.diet);

  DietState copyWith({
    Diet? diet_,
  }) {
    return DietState(diet_ ?? diet);
  }
}

abstract class DayState {
  Day get day;
}

// --------------------------
class AddMealToDayState extends DietState implements DayState {
  final Day day;
  const AddMealToDayState(super.diet, this.day);
}

class MealUpdateGramsState extends DietState implements DayState {
  final Day day;
  const MealUpdateGramsState(super.diet, this.day);
}

class DeleteMealFromDayState extends DietState implements DayState {
  final Day day;
  const DeleteMealFromDayState(super.diet, this.day);
}

class ReorderMealInDayState extends DietState implements DayState {
  final Day day;
  const ReorderMealInDayState(super.diet, this.day);
}

// ---------------------------
class RefreshDietState extends DietState {
  const RefreshDietState(super.diet);
}

class AddDayState extends DietState {
  const AddDayState(super.diet);
}

class ReorderDayState extends DietState {
  const ReorderDayState(super.diet);
}

class DuplicateDayState extends DietState {
  const DuplicateDayState(super.diet);
}

class DeleteDayState extends DietState {
  const DeleteDayState(super.diet);
}

bool isDayState(DietState state) {
  return state is AddMealToDayState ||
          state is MealUpdateGramsState ||
          state is DeleteMealFromDayState ||
          state is ReorderMealInDayState
      // state is  ||
      ;
}

bool affectsNutrition(DietState state) {
  return (isDayState(state) && state is! ReorderMealInDayState) ||
      state is DeleteDayState ||
      state is DuplicateDayState;
}
