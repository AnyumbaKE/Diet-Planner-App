import 'package:ari_utils/ari_utils.dart' as ari;
import 'package:diet_planner/mydataclasses/metadata.dart';
import 'dart:convert';
import 'package:dataclasses/dataclasses.dart';
import 'package:diet_planner/domain.dart';
import 'package:diet_planner/utils.dart';
import 'package:diet_planner/utils/utils.dart';

/// AGG ROOT
@Dataclass()
class App {
  Settings settings;
  Map<String, Diet> diets;
  Map<String, Meal> meals;
  Map<String, Ingredient> baseIngredients;
  List<MealComponentFactory> get ingredients => [
        ...baseIngredients.values,
        ...meals.values.where((element) => element.isSubRecipe)
      ];

  void addMeal(Meal meal) {
    meals[meal.name] = meal;
    // saveMeal(meal);
    Saver().app(this);
  }

  void addBaseIngredient(Ingredient ingredient) {
    baseIngredients[ingredient.name] = ingredient;
    // saveIngredient(ingredient);
    Saver().app(this);
  }

  void addDiet(Diet diet) {
    diets[diet.name] = diet;
    // saveDietWithIsolate(diet);
    Saver().app(this);
  }

  void updateBaseIngredient(Ingredient ingToUpdate, Ingredient replacer) {
    deleteBaseIngredient(ingToUpdate);
    addBaseIngredient(replacer);
  }

  void updateMeal(Meal mealToUpdate, Meal replacer) {
    deleteMeal(mealToUpdate);
    addMeal(replacer);
  }

  void deleteMeal(Meal meal) {
    meals.remove(meal.name);
    // deleteMealFromSave(meal);
  }

  void deleteBaseIngredient(Ingredient ingredient) {
    baseIngredients.remove(ingredient.name);
    // deleteIngredientFromSave(ingredient);
  }

  void deleteDiet(Diet diet) {
    diets.remove(diet.name);
    // deleteDietFromSave(diet);
  }

  void renameDiet(Diet diet) {
    // TODO Implement and call in bloc
  }
  void reorderDiet(Diet diet) {
    // TODO Implement and call in bloc
  }

  factory App.newApp(Settings settings) =>
      App(settings: settings, diets: {}, meals: {}, baseIngredients: {});

  // <editor-fold desc="Dataclass Section">

  // <editor-fold desc="Singleton Pattern">
  // static late final App _singleton;
  //
  // factory App() {
  //   return _singleton;
  // }
  //
  // App._internal({
  //   required this.settings,
  //   required this.diets,
  //   required this.meals,
  //   required this.baseIngredients,
  // });
  //
  // factory App.restart({required Settings settings}) {
  //   _singleton = App._internal(
  //       settings: settings,
  //       diets: <Diet>[],
  //       meals: <Meal>[],
  //       baseIngredients: <Ingredient>[]);
  //   return _singleton;
  // }

  // </editor-fold>

  // <editor-fold desc="Custom Data Functions">
  // App update(
  //     {Settings? settings,
  //     List<Diet>? diets,
  //     List<Meal>? meals,
  //     List<Ingredient>? baseIngredients}) {
  //   _singleton = App._internal(
  //       settings: settings ?? this.settings,
  //       diets: diets ?? this.diets,
  //       meals: meals ?? this.meals,
  //       baseIngredients: baseIngredients ?? this.baseIngredients);
  //   return _singleton;
  // }
  //
  // factory App.fromMap(Map map) {
  //   Settings settings = dejsonify(map['settings']);
  //   List dietsTemp = dejsonify(map['diets']);
  //   List mealsTemp = dejsonify(map['meals']);
  //   List baseIngredientsTemp = dejsonify(map['baseIngredients']);
  //
  //   List<Diet> diets = List<Diet>.from(dietsTemp);
  //
  //   List<Meal> meals = List<Meal>.from(mealsTemp);
  //
  //   List<Ingredient> baseIngredients =
  //       List<Ingredient>.from(baseIngredientsTemp);
  //
  //   _singleton = App._internal(
  //       settings: settings,
  //       diets: diets,
  //       meals: meals,
  //       baseIngredients: baseIngredients);
  //   return _singleton;
  // }
  // factory App.fromJson(String json) => App.fromMap(jsonDecode(json));
  // </editor-fold>

  // <editor-fold desc="Regular Dataclass Section">
  @Generate()
  // <Dataclass>

  App({
    required this.settings,
    required this.diets,
    required this.meals,
    required this.baseIngredients,
  });

  factory App.staticConstructor({
    required settings,
    required diets,
    required meals,
    required baseIngredients,
  }) =>
      App(
          settings: settings,
          diets: diets,
          meals: meals,
          baseIngredients: baseIngredients);

  Map<String, dynamic> get attributes__ => {
        "settings": settings,
        "diets": diets,
        "meals": meals,
        "baseIngredients": baseIngredients
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is App &&
          runtimeType == other.runtimeType &&
          equals(settings, other.settings) &&
          equals(diets, other.diets) &&
          equals(meals, other.meals) &&
          equals(baseIngredients, other.baseIngredients));

  @override
  int get hashCode =>
      settings.hashCode ^
      diets.hashCode ^
      meals.hashCode ^
      baseIngredients.hashCode;

  @override
  String toString() =>
      'App(settings: $settings, diets: $diets, meals: $meals, baseIngredients: $baseIngredients)';

  App copyWithApp(
          {Settings? settings,
          Map<String, Diet>? diets,
          Map<String, Meal>? meals,
          Map<String, Ingredient>? baseIngredients}) =>
      App(
          settings: settings ?? this.settings,
          diets: diets ?? this.diets,
          meals: meals ?? this.meals,
          baseIngredients: baseIngredients ?? this.baseIngredients);

  String toJson() => jsonEncode(toMap());
  Map<String, dynamic> toMap() =>
      {'__type': 'App', ...nestedJsonMap(attributes__)};

  factory App.fromJson(String json) => App.fromMap(jsonDecode(json));

  factory App.fromMap(Map map) {
    Settings settings = dejsonify(map['settings']);
    Map dietsTemp = dejsonify(map['diets']);
    Map mealsTemp = dejsonify(map['meals']);
    Map baseIngredientsTemp = dejsonify(map['baseIngredients']);

    Map<String, Diet> diets = Map<String, Diet>.from(
        dietsTemp.map((__k0, __v0) => MapEntry(__k0 as String, __v0 as Diet)));

    Map<String, Meal> meals = Map<String, Meal>.from(
        mealsTemp.map((__k0, __v0) => MapEntry(__k0 as String, __v0 as Meal)));

    Map<String, Ingredient> baseIngredients = Map<String, Ingredient>.from(
        baseIngredientsTemp
            .map((__k0, __v0) => MapEntry(__k0 as String, __v0 as Ingredient)));

    return App(
        settings: settings,
        diets: diets,
        meals: meals,
        baseIngredients: baseIngredients);
  }
  // </Dataclass>
  // </editor-fold>

  // </editor-fold>
}

/// Diet Branch

@Dataclass(constructor: false)
class Diet {
  String name;
  List<Day> days;
  DRIS dris;
  late Map<String, List<MealComponent>> shoppingList;

  Nutrients get averageNutrition {
    final trueAvg = days.where((element) => element.nutrients != zeroNut);
    if (trueAvg.isEmpty) {
      return Nutrients.zero();
    }
    final dayNut = trueAvg.map((e) => e.nutrients);
    Nutrients sum = Nutrients.sum(dayNut);
    return sum / trueAvg.length;
  }

  void createDay() {
    days.add(Day(name: (days.length + 1).toString(), meals: []));
  }

  static Future<Diet> create(String name, Settings settings) async {
    try {
      final dris = await DRIS.fromAPI(settings.anthroMetrics);
      return Diet(name: name, days: <Day>[], dris: dris);
    } on Exception catch (_) {
      rethrow;
    }
  }
  // For update access by index setter days[index] = newDay;

  void removeDay(Day day) {
    days.remove(day);
    refreshDays();
  }

  void refreshDays() {
    for (int i in ari.range(days.length)) {
      days[i].name = (i + 1).toString();
    }
  }

  void reorderDay(int old, int new_) {
    days = days.reIndex(old, new_);
    refreshDays();
  }

  void duplicateDay(int index) {
    final duplicate = days[index].copyWithDay();
    if (index >= days.length - 1) {
      days.add(duplicate);
    } else {
      days.insert(index, duplicate);
    }
    refreshDays();
  }

  List<MealComponent> initShoppingList() {
    List container = [];
    for (Day day in days) {
      for (MealComponent meal in day.meals) {
        container.add(meal.getBaseIngredients());
      }
    }
    List<MealComponent> flattened = flatten<MealComponent>(container).toList();
    final result = combineListValuesToMap<MealComponent, String, MealComponent>(
        flattened,
        (elemToKey) => elemToKey.name,
        (elemToValue) => elemToValue,
        (existingSameKeyValue, newSameKeyValue) =>
            existingSameKeyValue.copyWithMealComponent(
                grams: existingSameKeyValue.grams + newSameKeyValue.grams));
    return result.values.toList();
  }

  void updateShoppingList() {
    Map<MealComponent, String> currentShoppingDummy = {};
    for (MapEntry<String, List<MealComponent>> keyList
        in shoppingList.entries) {
      currentShoppingDummy
          .addAll({for (MealComponent ing in keyList.value) ing: keyList.key});
    }
    final shoppingDummyForNames =
        currentShoppingDummy.map((key, value) => MapEntry(key.name, value));
    // Map<String, MealComponent> namesDummy = {
    //   for (MealComponent meal in currentShoppingDummy.keys) meal.name: meal
    // };
    shoppingList =
        shoppingList.map((key, value) => MapEntry(key, <MealComponent>[]));

    for (MealComponent mealComponent in initShoppingList()) {
      final String? itemCategory = shoppingDummyForNames[mealComponent.name];

      // Weight is the same
      if (currentShoppingDummy.keys.contains(mealComponent)) {
        shoppingList[itemCategory!]!.add(mealComponent);
        // continue; flutter is lit broken maps lit dont work
      }

      // Item is there but the weight changed
      else if (itemCategory != null) {
        shoppingList[itemCategory]!.add(mealComponent);
        // final temp = currentShoppingDummy[namesDummy[mealComponent.name]];
        // currentShoppingDummy.remove(namesDummy[mealComponent.name]);
        // currentShoppingDummy[mealComponent] = temp!;
      }

      // Item didn't exist before
      else {
        shoppingList['Good']!.add(mealComponent);
        // currentShoppingDummy[mealComponent] = 'Good';
      }
    }
    // shoppingList = {
    //   'Good': [],
    //   'Running Low': [],
    //   'Out of Stock': [],
    //   'On the Way': []
    // };

    // for (MapEntry<MealComponent, String> entry
    //     in currentShoppingDummy.entries) {
    //   shoppingList[entry.value]?.add(entry.key);
    // }
  }

  // <editor-fold desc="Dataclass Section">
  Diet(
      {required this.name,
      required this.days,
      required this.dris,
      Map<String, List<MealComponent>>? shoppingList}) {
    this.shoppingList = shoppingList ??
        {
          'Good': initShoppingList(),
          'Running Low': [],
          'Out of Stock': [],
          'On the Way': []
        };
  }

  // <Dataclass>

  factory Diet.staticConstructor(
          {required name,
          required days,
          required dris,
          Map<String, List<MealComponent>>? shoppingList}) =>
      Diet(name: name, days: days, dris: dris, shoppingList: shoppingList);

  Map<String, dynamic> get attributes__ =>
      {"name": name, "days": days, "dris": dris, "shoppingList": shoppingList};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Diet &&
          runtimeType == other.runtimeType &&
          equals(name, other.name) &&
          equals(days, other.days) &&
          equals(dris, other.dris) &&
          equals(shoppingList, other.shoppingList));

  @override
  int get hashCode =>
      name.hashCode ^ days.hashCode ^ dris.hashCode ^ shoppingList.hashCode;

  @override
  String toString() =>
      'Diet(name: $name, days: $days, dris: $dris, shoppingList: $shoppingList)';

  Diet copyWithDiet(
          {String? name,
          List<Day>? days,
          DRIS? dris,
          Map<String, List<MealComponent>>? shoppingList}) =>
      Diet(
          name: name ?? this.name,
          days: days ?? this.days,
          dris: dris ?? this.dris,
          shoppingList: shoppingList ?? this.shoppingList);

  String toJson() => jsonEncode(toMap());
  Map<String, dynamic> toMap() =>
      {'__type': 'Diet', ...nestedJsonMap(attributes__)};

  factory Diet.fromJson(String json) => Diet.fromMap(jsonDecode(json));

  factory Diet.fromMap(Map map) {
    String name = map['name'];
    List daysTemp = dejsonify(map['days']);
    DRIS dris = dejsonify(map['dris']);
    Map shoppingTemp = dejsonifyMap(map['shoppingList']);

    List<Day> days = List<Day>.from(daysTemp);
    Map<String, List<MealComponent>> shoppingList =
        Map<String, List<MealComponent>>.from(shoppingTemp.map(
            (key, value) => MapEntry(key, List<MealComponent>.from(value))));

    return Diet(name: name, days: days, dris: dris, shoppingList: shoppingList);
  }
  // </Dataclass>

  // </editor-fold>
}

@Dataclass()
class Day {
  String name;
  List<MealComponent> meals;

  Nutrients get nutrients => meals.isEmpty
      ? Nutrients.zero()
      : Nutrients.sum(meals.map((e) => e.nutrients));

  void addDayMeal(Meal meal) {
    meals.add(meal.toMealComponent('serving', 1, meal));
  }

  void addDayMealFromIng(Ingredient ing) {
    meals.add(ing.toMealComponent('grams', ing.baseNutrient.grams, ing));
  }

  void deleteDayMeal(int index) {
    meals.removeAt(index);
  }

  void updateMealServingSize(int index, String measure, num newAmount) {
    MealComponent newMeal = meals[index]
        .reference
        .toMealComponent(measure, newAmount, meals[index].reference);
    meals[index] = newMeal;
  }

  void reorderMeal(int oldIndex, int newIndex) {
    meals.reIndex(oldIndex, newIndex, inPlace: true);
  }

  // <editor-fold desc="Dataclass Section">
  @Generate()
  // <Dataclass>

  Day({
    required this.name,
    required this.meals,
  });

  factory Day.staticConstructor({
    required name,
    required meals,
  }) =>
      Day(name: name, meals: meals);

  Map<String, dynamic> get attributes__ => {"name": name, "meals": meals};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Day &&
          runtimeType == other.runtimeType &&
          equals(name, other.name) &&
          equals(meals, other.meals));

  @override
  int get hashCode => name.hashCode ^ meals.hashCode;

  @override
  String toString() => 'Day(name: $name, meals: $meals)';

  Day copyWithDay({String? name, List<MealComponent>? meals}) =>
      Day(name: name ?? this.name, meals: meals ?? this.meals);

  String toJson() => jsonEncode(toMap());
  Map<String, dynamic> toMap() =>
      {'__type': 'Day', ...nestedJsonMap(attributes__)};

  factory Day.fromJson(String json) => Day.fromMap(jsonDecode(json));

  factory Day.fromMap(Map map) {
    String name = map['name'];
    List mealsTemp = dejsonify(map['meals']);

    List<MealComponent> meals = List<MealComponent>.from(mealsTemp);

    return Day(name: name, meals: meals);
  }
  // </Dataclass>

  // </editor-fold>
}

@Dataclass()
class MealComponent {
  // String measure;
  // num quantity;
  MealComponentFactory reference;
  num grams;
  Nutrients get nutrients {
    num ratio = grams / reference.baseNutrient.grams;
    return reference.baseNutrient.nutrients * ratio;
  }

  String get name => reference.name;

  /// Returns List<MealComponent> or itself, depending on whether this references
  /// a Meal (List) or an Ingredient (Itself). In order to recursively get all
  /// leaf nodes.
  getBaseIngredients() {
    if (reference is Ingredient) {
      return this;
    } else {
      return reference.baseIngredients();
    }
  }

  // <editor-fold desc="Dataclass Section">
  @Generate()
  // <Dataclass>

  MealComponent({
    required this.reference,
    required this.grams,
  });

  factory MealComponent.staticConstructor({
    required reference,
    required grams,
  }) =>
      MealComponent(reference: reference, grams: grams);

  Map<String, dynamic> get attributes__ =>
      {"reference": reference, "grams": grams};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MealComponent &&
          runtimeType == other.runtimeType &&
          equals(reference, other.reference) &&
          equals(grams, other.grams));

  @override
  int get hashCode => reference.hashCode ^ grams.hashCode;

  @override
  String toString() => 'MealComponent(reference: $reference, grams: $grams)';

  MealComponent copyWithMealComponent(
          {MealComponentFactory? reference, num? grams}) =>
      MealComponent(
          reference: reference ?? this.reference, grams: grams ?? this.grams);

  String toJson() => jsonEncode(toMap());
  Map<String, dynamic> toMap() =>
      {'__type': 'MealComponent', ...nestedJsonMap(attributes__)};

  factory MealComponent.fromJson(String json) =>
      MealComponent.fromMap(jsonDecode(json));

  factory MealComponent.fromMap(Map map) {
    MealComponentFactory reference = dejsonify(map['reference']);
    num grams = map['grams'];

    // No casting

    return MealComponent(reference: reference, grams: grams);
  }
  // </Dataclass>

// </editor-fold>
}

final zeroNut = Nutrients.zero();
