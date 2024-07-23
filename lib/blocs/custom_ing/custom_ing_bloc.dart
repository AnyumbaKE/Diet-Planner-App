import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/domain.dart';
import 'package:diet_planner/utils.dart';

part 'custom_ing_event.dart';

part 'custom_ing_state.dart';

void newState(emit, CustomIngState state) {
  if (state is CustomIngErrors) {
    emit(CustomIngErrors.fromState(state));
  } else {
    emit(CustomIngState.fromState(state));
  }
}

class CustomIngBloc extends Bloc<CustomIngEvent, CustomIngState> {
  CustomIngBloc([Ingredient? refIngredient])
      : super(refIngredient == null
            ? CustomIngState.initial()
            : CustomIngState.fromIngredient(refIngredient)) {
    on<CustomIngEvent>((event, emit) {});
    on<AddAltMeasureCI>((event, emit) {
      state.altMeasures.add(const MapEntry('', ''));
      newState(emit, state);
    });
    on<ChangeAltMeasureNameCI>((event, emit) {
      final currentGrams = state.altMeasures[event.index].value;
      state.altMeasures[event.index] = MapEntry(event.newName, currentGrams);
      newState(emit, state);
    });
    on<ChangeAltMeasureValueCI>((event, emit) {
      final currentName = state.altMeasures[event.index].key;
      state.altMeasures[event.index] = MapEntry(currentName, event.newValue);
      newState(emit, state);
    });
    on<ChangeNutrientValueCI>((event, emit) {
      state.nutrientFields[event.nut.name] = event.value;
      newState(emit, state);
    });
    on<ChangeNameCI>((event, emit) {
      state.name = event.name;
      newState(emit, state);
    });
    on<ChangeGramsCI>((event, emit) {
      state.baseGrams = event.value;
      newState(emit, state);
    });
    on<NewImageCI>((event, emit) {
      state.image = event.path;
      emit(CustomIngAddedPhoto.fromState(state));
    });
    on<OnSubmitCI>((event, emit) async {
      if (state.isInvalid()) {
        emit(CustomIngErrors.fromState(state));
        return;
      }
      final result = await state.toIngredient();
      emit(CustomIngSuccess.fromState(state, result));
    });
  }
}
