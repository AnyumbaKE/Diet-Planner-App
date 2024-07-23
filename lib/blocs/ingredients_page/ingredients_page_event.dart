part of 'ingredients_page_bloc.dart';

abstract class IngredientsPageEvent {}

class OnSubmitSolo extends IngredientsPageEvent {
  MealComponentFactory ingredient;
  MealComponentFactory? ingToReplace;

  OnSubmitSolo(this.ingredient, {this.ingToReplace});
}

class OnSubmitWithRef extends IngredientsPageEvent {}

class UpdateSearchIng extends IngredientsPageEvent {
  String searchVal;
  UpdateSearchIng(this.searchVal);
}

class IngPageAPIErrorEvent extends IngredientsPageEvent {
  String message;

  IngPageAPIErrorEvent(this.message);
}

class IngPageIncludeSubRecipes extends IngredientsPageEvent {
  bool toggle;

  IngPageIncludeSubRecipes(this.toggle);
}

class IngDelete extends IngredientsPageEvent {
  MealComponentFactory ingredient;

  IngDelete(this.ingredient);
}

class IngDuplicate extends IngredientsPageEvent {
  MealComponentFactory ingredient;

  IngDuplicate(this.ingredient);
}
