import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/domain.dart';
import 'package:diet_planner/utils.dart';

part 'index_event.dart';

part 'index_state.dart';

final duplicateRegex = RegExp(r'\((\d+)\)$');

class IndexBloc extends Bloc<IndexEvent, IndexState> {
  IndexBloc(App app) : super(IndexState(app)) {
    on<IndexEvent>((event, emit) {});
    on<AddDiet>((event, emit) async {
      try {
        state.app.addDiet(await Diet.create(event.name, state.app.settings));
        emit(state.copyWith());
      } on Exception catch (e) {
        emit(FailedToLoadDiet(state.app, e.toString()));
      }
    });
    on<RenameDiet>((event, emit) async {
      // TODO Deal with overrides in general
      state.app.deleteDiet(event.diet);
      event.diet.name = event.newName;
      state.app.diets[event.newName] = event.diet;
      emit(state.copyWith());
    });
    on<DuplicateDiet>((event, emit) {
      // Match? match = duplicateRegex.firstMatch(event.diet.name);
      // String duplicateName = '${event.diet.name} (2)';
      // if (match != null){
      //   duplicateName = '${event.diet.name.substring(0, event.diet.name.length - 4)} '
      //       '(${(int.parse(match.group(1)!) + 1)})';
      // }
      state.app.addDiet(event.diet.copyWithDiet(
          name: duplicateNamer(state.app.diets.values, event.diet)));
      emit(state.copyWith());
    });
    on<DeleteDiet>((event, emit) async {
      state.app.deleteDiet(event.diet);
      emit(state.copyWith());
    });
    on<ReorderDiet>((event, emit) async {
      state.app.diets =
          reorderMap(state.app.diets, event.oldIndex, event.newIndex);
      saveDietsOrder(state.app.diets.values);
      emit(state.copyWith());
    });
  }
}
