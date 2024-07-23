import 'package:ari_utils/ari_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/domain.dart';
import 'package:diet_planner/utils.dart';
part 'diet_event.dart';
part 'diet_state.dart';

class DietBloc extends Bloc<DietEvent, DietState> {
  DietBloc(Diet diet) : super(DietState(diet)) {
    on<DietEvent>((event, emit) {});
    on<AddDay>((event, emit) {
      state.diet.createDay();
      emit(AddDayState(state.diet));
    });
    on<AddMealToDay>((event, emit) {
      event.day.addDayMeal(event.meal);
      emit(AddMealToDayState(state.diet, event.day));
    });
    on<EditMealInDay>((event, emit) {
      if (event.factory is Meal) {
        event.app.updateMeal(event.mc.reference as Meal, event.factory as Meal);
      } else if (event.factory is Ingredient) {
        event.app.updateBaseIngredient(
            event.mc.reference as Ingredient, event.factory as Ingredient);
      }
      final newMc =
          event.factory.toMealComponent('grams', event.mc.grams, event.factory);
      final copy = List<MealComponent>.from(event.day.meals);
      copy.remove(event.mc);
      // <editor-fold desc="Add or Insert newMC">
      try {
        copy.insert(event.index, newMc);
      } catch (_) {
        copy.add(newMc);
      }
// </editor-fold>
      event.day.meals = copy;
      emit(AddMealToDayState(state.diet, event.day));
    });
    on<AddIngredientToDay>((event, emit) {
      event.day.addDayMealFromIng(event.ingredient);
      emit(AddMealToDayState(state.diet, event.day));
    });

    on<MealUpdateGrams>((event, emit) {
      event.day.updateMealServingSize(event.index, event.serving, event.value);
      emit(MealUpdateGramsState(state.diet, event.day));
    });

    on<DeleteMealFromDay>((event, emit) {
      event.day.deleteDayMeal(event.index);
      emit(DeleteMealFromDayState(state.diet, event.day));
    });

    on<ReorderMealInDay>((event, emit) {
      event.day.reorderMeal(event.old, event.new_);
      emit(ReorderMealInDayState(state.diet, event.day));
    });

    on<ReorderDay>((event, emit) {
      state.diet.reorderDay(event.old, event.new_);
      emit(ReorderDayState(state.diet));
    });

    on<DuplicateDay>((event, emit) {
      state.diet.duplicateDay(event.dayIndex);
      emit(DuplicateDayState(state.diet));
    });

    on<DeleteDay>((event, emit) {
      state.diet.removeDay(event.day);
      emit(DeleteDayState(state.diet));
    });
    on<DuplicateMealInDay>((event, emit) {
      event.day.meals.add(event.meal);
      emit(AddMealToDayState(state.diet, event.day));
    });
  }
}
