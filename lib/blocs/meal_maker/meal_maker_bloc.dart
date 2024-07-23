import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/domain.dart';
import 'package:diet_planner/utils.dart';
part 'meal_maker_event.dart';
part 'meal_maker_state.dart';

class MealMakerBloc extends Bloc<MealMakerEvent, MealMakerState> {
  MealMakerBloc([Meal? ref])
      : super(ref == null
            ? MealMakerState.fromNew()
            : MealMakerState.fromMeal(ref)) {
    on<MealMakerEvent>((event, emit) {});
    on<ChangePhoto>((event, emit) {
      emit(state.copyWith(image: event.uri));
    });
    on<ChangeName>((event, emit) {
      emit(state.copyWith(name: event.name));
    });
    on<ChangeServings>((event, emit) {
      emit(state.copyWith(servings: event.serving));
    });
    on<UpdateNotes>((event, emit) {
      emit(state.copyWith(notes: event.notes));
    });
    on<AddMC>((event, emit) {
      if (state.mealComponents.map((e) => e.name).contains(event.mc.name)) {
        return;
      }
      if (event.mc.reference == ref) {
        return;
      }
      final copy = List<MealComponent>.from(state.mealComponents);
      copy.add(event.mc);
      emit(state.copyWith(mealComponents: copy));
    });
    on<DeleteMC>((event, emit) {
      final copy = List<MealComponent>.from(state.mealComponents);
      copy.remove(event.mc);
      emit(state.copyWith(mealComponents: copy));
    });
    on<UpdateGramsMC>((event, emit) {
      final grams =
          event.mc.reference.altMeasures2grams[event.serving]! * event.grams;
      event.mc.grams = grams;
      // final copy = List<MealComponent>.from(state.mealComponents);
      // final index = copy.indexOf(event.mc);
      // copy[index] = event.mc.copyWithMealComponent(grams: event.grams);
      emit(MMChangeGrams.fromState(state));
    });
    on<EditMC>((event, emit) {
      if (event.factory is Meal) {
        event.app.updateMeal(event.mc.reference as Meal, event.factory as Meal);
      } else if (event.factory is Ingredient) {
        event.app.updateBaseIngredient(
            event.mc.reference as Ingredient, event.factory as Ingredient);
      }
      final newMc =
          event.factory.toMealComponent('grams', event.mc.grams, event.factory);
      final copy = List<MealComponent>.from(state.mealComponents);
      copy.remove(event.mc);
      // <editor-fold desc="Add or Insert newMC">
      try {
        copy.insert(event.index, newMc);
      } catch (_) {
        copy.add(newMc);
      }
// </editor-fold>
      emit(state.copyWith(mealComponents: copy));
    });
    on<ReorderMC>((event, emit) {
      final copy = List<MealComponent>.from(state.mealComponents);
      final item = copy[event.oldIndex];
      copy.removeAt(event.oldIndex);
      // <editor-fold desc="Insert">
      try {
        copy.insert(event.newIndex, item);
      } catch (e) {
        copy.add(item);
      }
// </editor-fold>
      emit(state.copyWith(mealComponents: copy));
    });
    on<ToggleSub>((event, emit) {
      emit(state.copyWith(subRecipe: event.toggle));
    });
    on<AltMeasureName>((event, emit) {
      final val = state.altMeasures[event.index].value;
      state.altMeasures[event.index] = MapEntry(event.name, val);
      emit(state.copyWith());
    });
    on<AltMeasureValue>((event, emit) {
      final name = state.altMeasures[event.index].key;
      state.altMeasures[event.index] = MapEntry(name, event.val);
      emit(state.copyWith());
    });
    on<AddAltMeasure>((event, emit) {
      state.altMeasures.add(const MapEntry('', ''));
      emit(state.copyWith());
    });
    on<SubmitMM>((event, emit) async {
      if (state.isInvalid()) {
        emit(MMError.fromState(state));
        return;
      }
      final result = await state.toMeal();
      emit(MMSuccess.fromState(state, result));
    });
    on<ChangeNutDisplayEvent>((event, emit) {
      final newState = ChangeNutDisplay.fromState(state);
      newState.nutPerServing = !state.nutPerServing;
      if (newState.nutPerServing && state.validServing()) {}
      emit(newState);
    });
  }
}
