import 'package:ari_utils/ari_utils.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:diet_planner/api/exceptions.dart';
import 'package:diet_planner/domain.dart';
import 'package:diet_planner/utils.dart';

part 'ingredients_page_event.dart';

part 'ingredients_page_state.dart';

class IngredientsPageBloc
    extends Bloc<IngredientsPageEvent, IngredientsPageState> {
  IngredientsPageBloc(App app, MCFTypes mcfType, {bool? include, bool? backRef})
      : super(mcfType == MCFTypes.ingredient
            ? IngredientsPageState.initialIngredient(app,
                include: toBool(include), backRef: toBool(backRef))
            : IngredientsPageState.initialMeal(app, backRef: toBool(backRef))) {
    on<IngredientsPageEvent>((event, emit) {});
    on<IngPageAPIErrorEvent>((event, emit) {
      emit(IngPageApiError.fromState(state, event.message));
    });
    on<UpdateSearchIng>((event, emit) {
      state.currentText = event.searchVal;
      List<MealComponentFactory> base = state.includeSubRecipes
          ? state.app.ingredients
          : state.app.baseIngredients.values.toList();
      if (state.isMeal()) {
        base = state.includeSubRecipes
            ? state.app.meals.values.toList()
            : state.app.meals.values
                .where((element) => !element.isSubRecipe)
                .toList();
      }
      final first = base.where((element) =>
          element.name.toLowerCase().startsWith(event.searchVal.toLowerCase()));
      final second = base.where((element) =>
          element.name.toLowerCase().contains(event.searchVal.toLowerCase()) &&
          !(element.name
              .toLowerCase()
              .startsWith(event.searchVal.toLowerCase())));

      emit(state.copyWith(searchResults_: [...first, ...second]));
    });
    on<OnSubmitSolo>((event, emit) {
      if (event.ingredient is Ingredient) {
        if (event.ingToReplace != null) {
          state.app.updateBaseIngredient(
              event.ingToReplace as Ingredient, event.ingredient as Ingredient);
        } else {
          state.app.addBaseIngredient(event.ingredient as Ingredient);
        }
      }
      // Else is Meal
      else {
        if (event.ingToReplace != null) {
          state.app
              .updateMeal(event.ingToReplace as Meal, event.ingredient as Meal);
        } else {
          state.app.addMeal(event.ingredient as Meal);
        }
      }

      emit(IngPageSuccessfulCreation.fromState(
          state.isIngredient()
              ? // Uses this to tell which screens its from not the specifics of the returned object
              IngredientsPageState.initialIngredient(state.app,
                  include: state.includeSubRecipes,
                  backRef: state.backReference)
              : IngredientsPageState.initialMeal(state.app,
                  backRef: state.backReference),
          event.ingredient));
      // saveApp(state.app);
    });
    on<IngPageIncludeSubRecipes>((event, emit) {
      state.includeSubRecipes = event.toggle;
      add(UpdateSearchIng(state.currentText));
    });
    on<IngDuplicate>((event, emit) {
      if (event.ingredient is Ingredient) {
        app.addBaseIngredient((event.ingredient as Ingredient)
            .copyWithIngredient(
                name: duplicateNamer(
                    state.app.baseIngredients.values, event.ingredient)));
      } else {
        app.addMeal((event.ingredient as Meal).copyWithMeal(
            name: duplicateNamer(state.app.meals.values, event.ingredient)));
      }
      add(UpdateSearchIng(state.currentText));
    });
    on<IngDelete>((event, emit) {
      if (event.ingredient is Ingredient) {
        app.deleteBaseIngredient(event.ingredient as Ingredient);
      } else {
        app.deleteMeal(event.ingredient as Meal);
      }
      add(UpdateSearchIng(state.currentText));
    });
  }
}
