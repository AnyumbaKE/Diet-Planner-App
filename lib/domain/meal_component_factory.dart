import 'dart:convert';
import 'package:dataclasses/dataclasses.dart';
import 'package:dio/dio.dart';
import 'package:diet_planner/api/nutritionix.dart';
import 'package:diet_planner/domain.dart';
import 'package:diet_planner/mydataclasses/metadata.dart';
import 'package:diet_planner/utils/utils.dart';

/// Interfaces
abstract class MealComponentFactory {
  String name;
  BaseNutrients baseNutrient;
  Map<String, num> altMeasures2grams;
  late String unit;

  MealComponentFactory(this.baseNutrient, this.altMeasures2grams, this.name,
      {String baseUnit = 'grams'}) {
    altMeasures2grams[baseUnit] = 1;
    unit = baseUnit;
  }

  MealComponent toMealComponent(
      String measure, num quantity, MealComponentFactory reference) {
    num grams = quantity * altMeasures2grams[measure]!;
    return MealComponent(grams: grams, reference: reference);
  }

  Uri? get photo => null;

  baseIngredients(); // MealComponent | List<MealComponent>

  MealComponent toServing() =>
      MealComponent(reference: this, grams: baseNutrient.grams);
}

/// Meal Component Implementation
/// Infinitive (Includes: Meal)

@Dataclass()
class Ingredient extends MealComponentFactory {
  // <editor-fold desc="Parent Attrs">
  @Super('+++')
  String name;
  @Super('+')
  BaseNutrients baseNutrient;
  @Super('++')
  Map<String, num> altMeasures2grams;
  @override
  Uri? photo;

  // </editor-fold>
  IngredientSource source;
  dynamic sourceMetadata;

  /// Use in a try except block
  static Future<Ingredient> fromApi(Settings settings, sourceMetadata) async {
    try {
      IngredientSource source;
      Response json;
      if (sourceMetadata is String) {
        if (RegExp(r'^\d+$').hasMatch(sourceMetadata)) {
          // MAKE SURE THE BARCODE IS 12 CHAR LONG ERROR?
          return fromApi(settings, int.parse(sourceMetadata));
        } else {
          source = IngredientSource.string;
          json = await apiCallFromString(sourceMetadata, settings);
        }
      } else if (sourceMetadata is int) {
        source = IngredientSource.upc;
        json = await apiCallFromUpc(sourceMetadata, settings);
      } else {
        throw Exception('$sourceMetadata type(${sourceMetadata.runtimeType})is '
            'not String or int and cannot be called from nutritionix API');
      }
      Map body = json.data['foods'][0];
      return Ingredient.fromResponseBody(
          responseBody: body, source: source, sourceMetadata: sourceMetadata);
    } catch (_) {
      rethrow;
    }
  }

  factory Ingredient.fromResponseBody(
      {required Map responseBody,
      required IngredientSource source,
      required sourceMetadata}) {
    /// assert serving_qty == 1
    /// serving_unit
    // Ingredient(name: name, baseNutrient: baseNutrient, altMeasures2grams: altMeasures2grams, source: source, sourceMetadata: )
    final String? baseUnit = responseBody['serving_weight_grams'] != null
        ? null
        : responseBody['nf_metric_uom'];
    final baseNutrient = BaseNutrients(
        // ADD CASE WHERE SERVING WEIGHT GRAMS IS NULL DEFAULT TO SERVING UNIT
        // BREAK CASE GF SOY SAUCE
        // (Currently fixed but will be on the look out for more break cases)
        grams: responseBody['serving_weight_grams'] ??
            responseBody['nf_metric_qty'],
        nutrients: Nutrients.fromResponseBody(responseBody));
    Map<String, num> altMeasures2grams;
    const default_serving_name = 'serving size';
    if (responseBody['alt_measures'] != null) {
      altMeasures2grams = {
        if (source == IngredientSource.upc)
          default_serving_name: responseBody['serving_weight_grams'] ??
              responseBody['nf_metric_qty'],
        ...{
          for (Map alt in responseBody['alt_measures'])
            alt['measure']: alt['serving_weight']
        }
      };
    } else {
      altMeasures2grams = {
        default_serving_name: responseBody['serving_weight_grams'] ??
            responseBody['nf_metric_qty'],
      };
    }
    String name = responseBody['food_name'];
    String? photo =
        responseBody['photo']['highres'] ?? responseBody['photo']['thumb'];
    return Ingredient(
        name: name,
        baseNutrient: baseNutrient,
        photo: photo == null ? null : Uri.parse(photo),
        altMeasures2grams: altMeasures2grams,
        source: source,
        sourceMetadata: sourceMetadata,
        baseUnit: baseUnit);
  }

  @override
  baseIngredients() => this;

  // <editor-fold desc="Dataclass Section">

  // <Dataclass>

  Ingredient(
      {required this.name,
      required this.baseNutrient,
      required this.altMeasures2grams,
      required this.source,
      this.photo,
      this.sourceMetadata,
      String? baseUnit})
      : super(baseNutrient, altMeasures2grams, name,
            baseUnit: baseUnit ?? 'grams');

  factory Ingredient.staticConstructor(
          {required name,
          required baseNutrient,
          required altMeasures2grams,
          required source,
          photo,
          sourceMetadata}) =>
      Ingredient(
          name: name,
          baseNutrient: baseNutrient,
          altMeasures2grams: altMeasures2grams,
          source: source,
          photo: photo,
          sourceMetadata: sourceMetadata);

  Map<String, dynamic> get attributes__ => {
        "name": name,
        "baseNutrient": baseNutrient,
        "altMeasures2grams": altMeasures2grams,
        "photo": photo,
        "source": source,
        "sourceMetadata": sourceMetadata,
        "unit": unit
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Ingredient &&
          runtimeType == other.runtimeType &&
          equals(name, other.name) &&
          equals(baseNutrient, other.baseNutrient) &&
          equals(altMeasures2grams, other.altMeasures2grams) &&
          equals(photo, other.photo) &&
          equals(source, other.source) &&
          equals(sourceMetadata, other.sourceMetadata) &&
          equals(unit, other.unit));

  @override
  int get hashCode =>
      name.hashCode ^
      baseNutrient.hashCode ^
      altMeasures2grams.hashCode ^
      photo.hashCode ^
      source.hashCode ^
      sourceMetadata.hashCode ^
      unit.hashCode;

  @override
  String toString() =>
      'Ingredient(name: $name, baseNutrient: $baseNutrient, altMeasures2grams: $altMeasures2grams, photo: $photo, source: $source, sourceMetadata: $sourceMetadata, unit: $unit)';

  Ingredient copyWithIngredient(
          {String? name,
          BaseNutrients? baseNutrient,
          Map<String, num>? altMeasures2grams,
          Uri? photo,
          IngredientSource? source,
          dynamic sourceMetadata,
          String? baseUnit}) =>
      Ingredient(
          name: name ?? this.name,
          baseNutrient: baseNutrient ?? this.baseNutrient,
          altMeasures2grams: altMeasures2grams ?? this.altMeasures2grams,
          photo: photo ?? this.photo,
          source: source ?? this.source,
          sourceMetadata: sourceMetadata ?? this.sourceMetadata,
          baseUnit: baseUnit ?? unit);

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() =>
      {'__type': 'Ingredient', ...nestedJsonMap(attributes__)};

  factory Ingredient.fromJson(String json) =>
      Ingredient.fromMap(jsonDecode(json));

  factory Ingredient.fromMap(Map map) {
    String name = map['name'];
    BaseNutrients baseNutrient = dejsonify(map['baseNutrient']);
    Map altMeasures2gramsTemp = dejsonify(map['altMeasures2grams']);
    Uri? photo = dejsonify(map['photo']);
    IngredientSource source = dejsonify(map['source']);
    dynamic sourceMetadata = dejsonify(map['sourceMetadata']);
    String? unit = map['unit'];

    Map<String, num> altMeasures2grams = Map<String, num>.from(
        altMeasures2gramsTemp
            .map((__k0, __v0) => MapEntry(__k0 as String, __v0 as num)));

    return Ingredient(
        name: name,
        baseNutrient: baseNutrient,
        altMeasures2grams: altMeasures2grams,
        photo: photo,
        source: source,
        sourceMetadata: sourceMetadata,
        baseUnit: unit);
  }
// </Dataclass>

// </editor-fold>
}

@Dataclass(constructor: false, attributes: false)
class Meal extends MealComponentFactory {
  @Super('+++')
  String name;
  List<MealComponent> ingredients;
  int servings;
  bool isSubRecipe;
  @override
  Uri? photo;
  String notes = '';

  @override
  List<MealComponent> baseIngredients() =>
      combineListValuesToMap<MealComponent, String, MealComponent>(
          flatten<MealComponent>(ingredients.map((e) => e.getBaseIngredients()))
              .toList(),
          (MealComponent key) => key.name,
          (MealComponent value) => value,
          (MealComponent k1, MealComponent k2) => k1.copyWithMealComponent(
              grams: k1.grams + k2.grams)).values.toList();

  // <editor-fold desc="Dataclass Section">
  Meal(
      {required this.name,
      required this.ingredients,
      this.servings = 1,
      this.photo,
      this.notes = '',
      required this.isSubRecipe,
      Map<String, num>? alt2grams})
      : super(
            BaseNutrients(
                grams: (ingredients
                        .map((e) => e.grams)
                        .toList()
                        .reduce((previous, current) => previous + current)) /
                    servings,
                nutrients: Nutrients.sum(
                        ingredients.map((e) => e.nutrients).toList()) /
                    servings),
            alt2grams ?? {},
            name) {
    altMeasures2grams['serving'] = (ingredients
            .map((e) => e.grams)
            .toList()
            .reduce((previous, current) => previous + current)) /
        servings;
  }

  Map<String, dynamic> get attributes__ => {
        "name": name,
        "ingredients": ingredients,
        "servings": servings,
        "isSubRecipe": isSubRecipe,
        "photo": photo,
        "baseNutrient": baseNutrient,
        "altMeasures2grams": altMeasures2grams,
        "notes": notes
      };

  //@Generate()
  // <Dataclass>

  factory Meal.staticConstructor(
          {required name,
          required ingredients,
          required servings,
          required isSubRecipe,
          photo,
          notes,
          alt2grams}) =>
      Meal(
          name: name,
          ingredients: ingredients,
          servings: servings,
          isSubRecipe: isSubRecipe,
          photo: photo,
          notes: notes,
          alt2grams: alt2grams);

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Meal &&
          runtimeType == other.runtimeType &&
          equals(name, other.name) &&
          equals(ingredients, other.ingredients) &&
          equals(servings, other.servings) &&
          equals(isSubRecipe, other.isSubRecipe) &&
          equals(notes, other.notes) &&
          equals(photo, other.photo) &&
          equals(altMeasures2grams, other.altMeasures2grams));

  @override
  int get hashCode =>
      name.hashCode ^
      ingredients.hashCode ^
      servings.hashCode ^
      isSubRecipe.hashCode ^
      photo.hashCode ^
      notes.hashCode ^
      altMeasures2grams.hashCode;

  @override
  String toString() =>
      'Meal(name: $name, ingredients: $ingredients, servings: $servings, isSubRecipe: $isSubRecipe, photo: $photo, notes: $notes, altmeasures2grams: $altMeasures2grams)';

  Meal copyWithMeal(
          {String? name,
          List<MealComponent>? ingredients,
          int? servings,
          bool? isSubRecipe,
          String? notes,
          Uri? photo,
          Map<String, num>? alt2grams}) =>
      Meal(
          name: name ?? this.name,
          ingredients: ingredients ?? this.ingredients,
          servings: servings ?? this.servings,
          isSubRecipe: isSubRecipe ?? this.isSubRecipe,
          notes: notes ?? this.notes,
          photo: photo ?? this.photo,
          alt2grams: alt2grams ?? altMeasures2grams);

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() =>
      {'__type': 'Meal', ...nestedJsonMap(attributes__)};

  factory Meal.fromJson(String json) => Meal.fromMap(jsonDecode(json));

  factory Meal.fromMap(Map map) {
    String name = map['name'];
    List ingredientsTemp = dejsonify(map['ingredients']);
    int servings = map['servings'];
    bool isSubRecipe = map['isSubRecipe'];
    String notes = map['notes'];
    Uri? photo = dejsonify(map['photo']);
    Map alt2gramsTemp = dejsonifyMap(map['altMeasures2grams']);

    List<MealComponent> ingredients = List<MealComponent>.from(ingredientsTemp);
    Map<String, num> alt2grams = Map<String, num>.from(alt2gramsTemp);

    return Meal(
        name: name,
        ingredients: ingredients,
        alt2grams: alt2grams,
        servings: servings,
        isSubRecipe: isSubRecipe,
        notes: notes,
        photo: photo);
  }
// </Dataclass>

// </editor-fold>
}
