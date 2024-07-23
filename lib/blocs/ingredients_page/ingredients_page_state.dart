part of 'ingredients_page_bloc.dart';

class IngredientsPageState {
  App app;
  bool includeSubRecipes;
  List<MealComponentFactory> searchResults;
  String currentText = '';
  bool backReference = false;
  MCFTypes type;
  bool isMeal() => type == MCFTypes.meal;
  bool isIngredient() => type == MCFTypes.ingredient;
  factory IngredientsPageState.initialIngredient(App app,
      {bool? include, bool backRef = false}) {
    return IngredientsPageState(
        app: app,
        includeSubRecipes: toBool(include),
        searchResults: toBool(include)
            ? app.ingredients
            : app.baseIngredients.values.toList(),
        backReference: backRef,
        type: MCFTypes.ingredient);
  }
  factory IngredientsPageState.initialMeal(App app, {bool backRef = false}) {
    final bool include = !backRef;
    return IngredientsPageState(
        app: app,
        includeSubRecipes: include,
        searchResults: include
            ? app.meals.values.toList()
            : app.meals.values
                .where((element) => !element.isSubRecipe)
                .toList(),
        backReference: backRef,
        type: MCFTypes.meal);
  }

  factory IngredientsPageState.fromState(IngredientsPageState state) =>
      IngredientsPageState(
          app: state.app,
          includeSubRecipes: state.includeSubRecipes,
          searchResults: state.searchResults,
          currentText: state.currentText,
          backReference: state.backReference,
          type: state.type);

  IngredientsPageState(
      {required this.app,
      required this.includeSubRecipes,
      required this.searchResults,
      required this.type,
      String? currentText,
      this.backReference = false}) {
    if (currentText != null) {
      this.currentText = currentText;
    }
  }

  IngredientsPageState copyWith({
    App? app_,
    bool? includeSubRecipes_,
    List<MealComponentFactory>? searchResults_,
    String? currentText_,
    bool? backRef,
  }) {
    return IngredientsPageState(
        app: app_ ?? app,
        includeSubRecipes: includeSubRecipes_ ?? includeSubRecipes,
        searchResults: searchResults_ ?? List.from(searchResults),
        currentText: currentText_ ?? currentText,
        type: type,
        backReference: backRef ?? backReference);
  }
}

class IngPageSuccessfulCreation extends IngredientsPageState {
  MealComponentFactory ingredient;

  IngPageSuccessfulCreation(
      {required super.app,
      required super.includeSubRecipes,
      required super.searchResults,
      required this.ingredient,
      required super.type,
      required super.backReference});

  factory IngPageSuccessfulCreation.fromState(
          IngredientsPageState state, MealComponentFactory newIngredient) =>
      IngPageSuccessfulCreation(
          app: state.app,
          includeSubRecipes: state.includeSubRecipes,
          searchResults: state.searchResults,
          ingredient: newIngredient,
          backReference: state.backReference,
          type: state.type);
}

class IngPageApiError extends IngredientsPageState {
  String message;

  IngPageApiError(
      {required this.message,
      required super.app,
      required super.includeSubRecipes,
      required super.searchResults,
      required super.currentText,
      required super.backReference,
      required super.type});

  factory IngPageApiError.fromState(
          IngredientsPageState state, String message) =>
      IngPageApiError(
          app: state.app,
          includeSubRecipes: state.includeSubRecipes,
          searchResults: state.searchResults,
          message: message,
          currentText: state.currentText,
          backReference: state.backReference,
          type: state.type);
}

// class IngredientsPageInitial extends IngredientsPageState {}