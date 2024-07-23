import 'package:diet_planner/domain/enums.dart';
import 'package:diet_planner/api/dri.dart';
import 'package:diet_planner/domain/diet_planner_domain.dart';
import 'package:ari_utils/ari_utils.dart';
import 'dart:convert';
import 'package:diet_planner/domain.dart';
import 'package:diet_planner/domain/data_carriers.dart';
import 'package:diet_planner/domain/meal_component_factory.dart';
import 'package:dataclasses/dataclasses.dart';
import 'package:diet_planner/api/nutritionix.dart';
import 'package:dio/dio.dart';
import 'package:diet_planner/utils/utils.dart';

List<ReflectedClass> dataclasses = [
  ReflectedClass(
      name: 'Nutrient',
      referenceType: ReflectedType.create(Nutrient, 'Nutrient'),
      dataclassAnnotation: Annotation.create('Dataclass', [],
          {'constructor': 'false', 'copyWith': 'false', 'toStr': 'false'}),
      attributes: [
        Attribute.create('value', ReflectedType.create(num, 'num'), true, false,
            false, false, false, null),
        Attribute.create('unit', ReflectedType.create(String, 'String'), true,
            false, false, false, false, null),
        Attribute.create('name', ReflectedType.create(String, 'String'), true,
            false, false, false, false, null)
      ],
      getters: [
        Getter.create(ReflectedType.create(Map, 'Map<String, dynamic>'),
            'attributes__', false, false),
        Getter.create(
            ReflectedType.create(int, 'int'), 'hashCode', false, false)
      ],
      methods: [
        Method.create('checkIfSame', ReflectedType.create(bool, 'bool'),
            MethodType.normal, false, null, false, null),
        Method.create('error', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create('errorCheck', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create('+', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.operator, false, null, false, null),
        Method.create('-', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.operator, false, null, false, null),
        Method.create('*', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.operator, false, null, false, null),
        Method.create('/', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.operator, false, null, false, null),
        Method.create('toString', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create('copyWith', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.normal, false, null, false, null),
        Method.create('Nutrient', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.constructor, false, null, false, null),
        Method.create('Calcium', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Calcium),
        Method.create(
            'Carbohydrate',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor,
            false,
            null,
            false,
            Nutrient.Carbohydrate),
        Method.create(
            'Cholesterol',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor,
            false,
            null,
            false,
            Nutrient.Cholesterol),
        Method.create('Calories', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Calories),
        Method.create(
            'SaturatedFat',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor,
            false,
            null,
            false,
            Nutrient.SaturatedFat),
        Method.create('TotalFat', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.TotalFat),
        Method.create('TransFat', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.TransFat),
        Method.create('Iron', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Iron),
        Method.create('Fiber', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Fiber),
        Method.create(
            'Potassium',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor,
            false,
            null,
            false,
            Nutrient.Potassium),
        Method.create('Sodium', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Sodium),
        Method.create('Protein', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Protein),
        Method.create('Sugars', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Sugars),
        Method.create('Choline', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Choline),
        Method.create('Copper', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Copper),
        Method.create('ALA', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.ALA),
        Method.create(
            'LinoleicAcid',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor,
            false,
            null,
            false,
            Nutrient.LinoleicAcid),
        Method.create('EPA', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.EPA),
        Method.create('DPA', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.DPA),
        Method.create('DHA', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.DHA),
        Method.create('Folate', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Folate),
        Method.create(
            'Magnesium',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor,
            false,
            null,
            false,
            Nutrient.Magnesium),
        Method.create(
            'Manganese',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor,
            false,
            null,
            false,
            Nutrient.Manganese),
        Method.create('Niacin', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Niacin),
        Method.create(
            'Phosphorus',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor,
            false,
            null,
            false,
            Nutrient.Phosphorus),
        Method.create(
            'PantothenicAcid',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor,
            false,
            null,
            false,
            Nutrient.PantothenicAcid),
        Method.create(
            'Riboflavin',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor,
            false,
            null,
            false,
            Nutrient.Riboflavin),
        Method.create('Selenium', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Selenium),
        Method.create('Thiamin', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Thiamin),
        Method.create('VitaminE', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.VitaminE),
        Method.create('VitaminA', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.VitaminA),
        Method.create(
            'VitaminB12',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor,
            false,
            null,
            false,
            Nutrient.VitaminB12),
        Method.create(
            'VitaminB6',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor,
            false,
            null,
            false,
            Nutrient.VitaminB6),
        Method.create('VitaminC', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.VitaminC),
        Method.create('VitaminD', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.VitaminD),
        Method.create('VitaminK', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.VitaminK),
        Method.create('Zinc', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor, false, null, false, Nutrient.Zinc),
        Method.create(
            'UnsaturatedFat',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.namedConstructor,
            false,
            null,
            false,
            Nutrient.UnsaturatedFat),
        Method.create(
            'staticConstructor',
            ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.factory,
            false,
            null,
            false,
            Nutrient.staticConstructor),
        Method.create('==', ReflectedType.create(bool, 'bool'),
            MethodType.operator, false, null, false, null),
        Method.create('toJson', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'toMap',
            ReflectedType.create(Map, 'Map<String, dynamic>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('fromJson', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.factory, false, null, false, Nutrient.fromJson),
        Method.create('fromMap', ReflectedType.create(Nutrient, 'Nutrient'),
            MethodType.factory, false, null, false, Nutrient.fromMap)
      ],
      parent: null,
      mixins: null,
      implementations: null),
  ReflectedClass(
      name: 'Ingredient',
      referenceType: ReflectedType.create(Ingredient, 'Ingredient'),
      dataclassAnnotation: Annotation.create('Dataclass', [], {}),
      attributes: [
        Attribute.create('name', ReflectedType.create(String, 'String'), false,
            false, false, false, false, null, '+++'),
        Attribute.create(
            'baseNutrient',
            ReflectedType.create(BaseNutrients, 'BaseNutrients'),
            false,
            false,
            false,
            false,
            false,
            null,
            '+'),
        Attribute.create(
            'altMeasures2grams',
            ReflectedType.create(Map, 'Map<String, num>'),
            false,
            false,
            false,
            false,
            false,
            null,
            '++'),
        Attribute.create('photo', ReflectedType.create(Uri, 'Uri?'), false,
            false, false, false, false, null),
        Attribute.create(
            'source',
            ReflectedType.create(IngredientSource, 'IngredientSource'),
            false,
            false,
            false,
            false,
            false,
            null),
        Attribute.create(
            'sourceMetadata',
            ReflectedType.create(dynamic, 'dynamic'),
            false,
            false,
            false,
            false,
            false,
            null)
      ],
      getters: [
        Getter.create(ReflectedType.create(Map, 'Map<String, dynamic>'),
            'attributes__', false, false),
        Getter.create(
            ReflectedType.create(int, 'int'), 'hashCode', false, false)
      ],
      methods: [
        Method.create(
            'fromApi',
            ReflectedType.create(Future, 'Future<Ingredient>'),
            MethodType.normal,
            true,
            null,
            false,
            Ingredient.fromApi),
        Method.create(
            'fromResponseBody',
            ReflectedType.create(Ingredient, 'Ingredient'),
            MethodType.factory,
            false,
            null,
            false,
            Ingredient.fromResponseBody),
        Method.create(
            'baseIngredients',
            ReflectedType.create(dynamic, 'dynamic'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create(
            'Ingredient',
            ReflectedType.create(Ingredient, 'Ingredient'),
            MethodType.constructor,
            false,
            null,
            false,
            null),
        Method.create(
            'staticConstructor',
            ReflectedType.create(Ingredient, 'Ingredient'),
            MethodType.factory,
            false,
            null,
            false,
            Ingredient.staticConstructor),
        Method.create('==', ReflectedType.create(bool, 'bool'),
            MethodType.operator, false, null, false, null),
        Method.create('toString', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'copyWithIngredient',
            ReflectedType.create(Ingredient, 'Ingredient'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('toJson', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'toMap',
            ReflectedType.create(Map, 'Map<String, dynamic>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create(
            'fromJson',
            ReflectedType.create(Ingredient, 'Ingredient'),
            MethodType.factory,
            false,
            null,
            false,
            Ingredient.fromJson),
        Method.create('fromMap', ReflectedType.create(Ingredient, 'Ingredient'),
            MethodType.factory, false, null, false, Ingredient.fromMap)
      ],
      parent: MealComponentFactory,
      mixins: null,
      implementations: null),
  ReflectedClass(
      name: 'MealComponent',
      referenceType: ReflectedType.create(MealComponent, 'MealComponent'),
      dataclassAnnotation: Annotation.create('Dataclass', [], {}),
      attributes: [
        Attribute.create(
            'reference',
            ReflectedType.create(MealComponentFactory, 'MealComponentFactory'),
            false,
            false,
            false,
            false,
            false,
            null),
        Attribute.create('grams', ReflectedType.create(num, 'num'), false,
            false, false, false, false, null)
      ],
      getters: [
        Getter.create(ReflectedType.create(Nutrients, 'Nutrients'), 'nutrients',
            false, false),
        Getter.create(
            ReflectedType.create(String, 'String'), 'name', false, false),
        Getter.create(ReflectedType.create(Map, 'Map<String, dynamic>'),
            'attributes__', false, false),
        Getter.create(
            ReflectedType.create(int, 'int'), 'hashCode', false, false)
      ],
      methods: [
        Method.create(
            'getBaseIngredients',
            ReflectedType.create(dynamic, 'dynamic'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create(
            'MealComponent',
            ReflectedType.create(MealComponent, 'MealComponent'),
            MethodType.constructor,
            false,
            null,
            false,
            null),
        Method.create(
            'staticConstructor',
            ReflectedType.create(MealComponent, 'MealComponent'),
            MethodType.factory,
            false,
            null,
            false,
            MealComponent.staticConstructor),
        Method.create('==', ReflectedType.create(bool, 'bool'),
            MethodType.operator, false, null, false, null),
        Method.create('toString', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'copyWithMealComponent',
            ReflectedType.create(MealComponent, 'MealComponent'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('toJson', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'toMap',
            ReflectedType.create(Map, 'Map<String, dynamic>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create(
            'fromJson',
            ReflectedType.create(MealComponent, 'MealComponent'),
            MethodType.factory,
            false,
            null,
            false,
            MealComponent.fromJson),
        Method.create(
            'fromMap',
            ReflectedType.create(MealComponent, 'MealComponent'),
            MethodType.factory,
            false,
            null,
            false,
            MealComponent.fromMap)
      ],
      parent: null,
      mixins: null,
      implementations: null),
  ReflectedClass(
      name: 'Nutrients',
      referenceType: ReflectedType.create(Nutrients, 'Nutrients'),
      dataclassAnnotation: Annotation.create('Dataclass', [], {}),
      attributes: [
        Attribute.create('calcium', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create(
            'carbohydrate',
            ReflectedType.create(Nutrient, 'Nutrient'),
            true,
            false,
            false,
            false,
            false,
            null),
        Attribute.create(
            'cholesterol',
            ReflectedType.create(Nutrient, 'Nutrient'),
            true,
            false,
            false,
            false,
            false,
            null),
        Attribute.create('calories', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create(
            'saturatedFat',
            ReflectedType.create(Nutrient, 'Nutrient'),
            true,
            false,
            false,
            false,
            false,
            null),
        Attribute.create('totalFat', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('transFat', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('iron', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('fiber', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create(
            'potassium',
            ReflectedType.create(Nutrient, 'Nutrient'),
            true,
            false,
            false,
            false,
            false,
            null),
        Attribute.create('sodium', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('protein', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('sugars', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('choline', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('copper', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('ala', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create(
            'linoleicAcid',
            ReflectedType.create(Nutrient, 'Nutrient'),
            true,
            false,
            false,
            false,
            false,
            null),
        Attribute.create('epa', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('dpa', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('dha', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('folate', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create(
            'magnesium',
            ReflectedType.create(Nutrient, 'Nutrient'),
            true,
            false,
            false,
            false,
            false,
            null),
        Attribute.create(
            'manganese',
            ReflectedType.create(Nutrient, 'Nutrient'),
            true,
            false,
            false,
            false,
            false,
            null),
        Attribute.create('niacin', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create(
            'phosphorus',
            ReflectedType.create(Nutrient, 'Nutrient'),
            true,
            false,
            false,
            false,
            false,
            null),
        Attribute.create(
            'pantothenicAcid',
            ReflectedType.create(Nutrient, 'Nutrient'),
            true,
            false,
            false,
            false,
            false,
            null),
        Attribute.create(
            'riboflavin',
            ReflectedType.create(Nutrient, 'Nutrient'),
            true,
            false,
            false,
            false,
            false,
            null),
        Attribute.create('selenium', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('thiamin', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('vitaminE', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('vitaminA', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create(
            'vitaminB12',
            ReflectedType.create(Nutrient, 'Nutrient'),
            true,
            false,
            false,
            false,
            false,
            null),
        Attribute.create(
            'vitaminB6',
            ReflectedType.create(Nutrient, 'Nutrient'),
            true,
            false,
            false,
            false,
            false,
            null),
        Attribute.create('vitaminC', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('vitaminD', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('vitaminK', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create('zinc', ReflectedType.create(Nutrient, 'Nutrient'),
            true, false, false, false, false, null),
        Attribute.create(
            'unsaturatedFat',
            ReflectedType.create(Nutrient, 'Nutrient'),
            true,
            false,
            false,
            true,
            false,
            null)
      ],
      getters: [
        Getter.create(ReflectedType.create(Map, 'Map<String, dynamic>'),
            'attributes__', false, false),
        Getter.create(
            ReflectedType.create(int, 'int'), 'hashCode', false, false)
      ],
      methods: [
        Method.create('+', ReflectedType.create(Nutrients, 'Nutrients'),
            MethodType.operator, false, null, false, null),
        Method.create('-', ReflectedType.create(Nutrients, 'Nutrients'),
            MethodType.operator, false, null, false, null),
        Method.create('*', ReflectedType.create(Nutrients, 'Nutrients'),
            MethodType.operator, false, null, false, null),
        Method.create('/', ReflectedType.create(Nutrients, 'Nutrients'),
            MethodType.operator, false, null, false, null),
        Method.create('sum', ReflectedType.create(Nutrients, 'Nutrients'),
            MethodType.normal, true, null, false, Nutrients.sum),
        Method.create(
            'fromResponseBody',
            ReflectedType.create(Nutrients, 'Nutrients'),
            MethodType.factory,
            false,
            null,
            false,
            Nutrients.fromResponseBody),
        Method.create(
            'fromValues',
            ReflectedType.create(Nutrients, 'Nutrients'),
            MethodType.factory,
            false,
            null,
            false,
            Nutrients.fromValues),
        Method.create('Nutrients', ReflectedType.create(Nutrients, 'Nutrients'),
            MethodType.constructor, false, null, false, null),
        Method.create(
            'staticConstructor',
            ReflectedType.create(Nutrients, 'Nutrients'),
            MethodType.factory,
            false,
            null,
            false,
            Nutrients.staticConstructor),
        Method.create('==', ReflectedType.create(bool, 'bool'),
            MethodType.operator, false, null, false, null),
        Method.create('toString', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create('toStr', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create('copyWith', ReflectedType.create(Nutrients, 'Nutrients'),
            MethodType.normal, false, null, false, null),
        Method.create('zero', ReflectedType.create(Nutrients, 'Nutrients'),
            MethodType.factory, false, null, false, Nutrients.zero),
        Method.create('toJson', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'toMap',
            ReflectedType.create(Map, 'Map<String, dynamic>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('fromJson', ReflectedType.create(Nutrients, 'Nutrients'),
            MethodType.factory, false, null, false, Nutrients.fromJson),
        Method.create('fromMap', ReflectedType.create(Nutrients, 'Nutrients'),
            MethodType.factory, false, null, false, Nutrients.fromMap)
      ],
      parent: null,
      mixins: null,
      implementations: null),
  ReflectedClass(
      name: 'Settings',
      referenceType: ReflectedType.create(Settings, 'Settings'),
      dataclassAnnotation: Annotation.create('Dataclass', [], {}),
      attributes: [
        Attribute.create('apikey', ReflectedType.create(String, 'String'),
            false, false, false, false, false, ''),
        Attribute.create('appId', ReflectedType.create(String, 'String'), false,
            false, false, false, false, ''),
        Attribute.create('darkMode', ReflectedType.create(bool, 'bool'), false,
            false, false, false, false, true),
        Attribute.create('measure', ReflectedType.create(Measure, 'Measure'),
            false, false, false, false, false, null),
        Attribute.create(
            'anthroMetrics',
            ReflectedType.create(AnthroMetrics, 'AnthroMetrics'),
            false,
            false,
            false,
            false,
            false,
            null)
      ],
      getters: [
        Getter.create(ReflectedType.create(Map, 'Map<String, dynamic>'),
            'attributes__', false, false),
        Getter.create(
            ReflectedType.create(int, 'int'), 'hashCode', false, false)
      ],
      methods: [
        Method.create('Settings', ReflectedType.create(Settings, 'Settings'),
            MethodType.constructor, false, null, false, null),
        Method.create(
            'staticConstructor',
            ReflectedType.create(Settings, 'Settings'),
            MethodType.factory,
            false,
            null,
            false,
            Settings.staticConstructor),
        Method.create('==', ReflectedType.create(bool, 'bool'),
            MethodType.operator, false, null, false, null),
        Method.create('toString', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'copyWithSettings',
            ReflectedType.create(Settings, 'Settings'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('toJson', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'toMap',
            ReflectedType.create(Map, 'Map<String, dynamic>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('fromJson', ReflectedType.create(Settings, 'Settings'),
            MethodType.factory, false, null, false, Settings.fromJson),
        Method.create('fromMap', ReflectedType.create(Settings, 'Settings'),
            MethodType.factory, false, null, false, Settings.fromMap)
      ],
      parent: null,
      mixins: null,
      implementations: null),
  ReflectedClass(
      name: 'App',
      referenceType: ReflectedType.create(App, 'App'),
      dataclassAnnotation: Annotation.create('Dataclass', [], {}),
      attributes: [
        Attribute.create('settings', ReflectedType.create(Settings, 'Settings'),
            false, false, false, false, false, null),
        Attribute.create(
            'diets',
            ReflectedType.create(Map, 'Map<String, Diet>'),
            false,
            false,
            false,
            false,
            false,
            null),
        Attribute.create(
            'meals',
            ReflectedType.create(Map, 'Map<String, Meal>'),
            false,
            false,
            false,
            false,
            false,
            null),
        Attribute.create(
            'baseIngredients',
            ReflectedType.create(Map, 'Map<String, Ingredient>'),
            false,
            false,
            false,
            false,
            false,
            null)
      ],
      getters: [
        Getter.create(ReflectedType.create(List, 'List<MealComponentFactory>'),
            'ingredients', false, false),
        Getter.create(ReflectedType.create(Map, 'Map<String, dynamic>'),
            'attributes__', false, false),
        Getter.create(
            ReflectedType.create(int, 'int'), 'hashCode', false, false)
      ],
      methods: [
        Method.create('addMeal', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create('addBaseIngredient', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create('addDiet', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create('deleteMeal', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'deleteBaseIngredient',
            ReflectedType.create(null, 'void'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('deleteDiet', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create('newApp', ReflectedType.create(App, 'App'),
            MethodType.factory, false, null, false, App.newApp),
        Method.create('App', ReflectedType.create(App, 'App'),
            MethodType.constructor, false, null, false, null),
        Method.create('staticConstructor', ReflectedType.create(App, 'App'),
            MethodType.factory, false, null, false, App.staticConstructor),
        Method.create('==', ReflectedType.create(bool, 'bool'),
            MethodType.operator, false, null, false, null),
        Method.create('toString', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create('copyWithApp', ReflectedType.create(App, 'App'),
            MethodType.normal, false, null, false, null),
        Method.create('toJson', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'toMap',
            ReflectedType.create(Map, 'Map<String, dynamic>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('fromJson', ReflectedType.create(App, 'App'),
            MethodType.factory, false, null, false, App.fromJson),
        Method.create('fromMap', ReflectedType.create(App, 'App'),
            MethodType.factory, false, null, false, App.fromMap)
      ],
      parent: null,
      mixins: null,
      implementations: null),
  ReflectedClass(
      name: 'Day',
      referenceType: ReflectedType.create(Day, 'Day'),
      dataclassAnnotation: Annotation.create('Dataclass', [], {}),
      attributes: [
        Attribute.create('name', ReflectedType.create(String, 'String'), false,
            false, false, false, false, null),
        Attribute.create(
            'meals',
            ReflectedType.create(List, 'List<MealComponent>'),
            false,
            false,
            false,
            false,
            false,
            null)
      ],
      getters: [
        Getter.create(ReflectedType.create(Nutrients, 'Nutrients'), 'nutrients',
            false, false),
        Getter.create(ReflectedType.create(Map, 'Map<String, dynamic>'),
            'attributes__', false, false),
        Getter.create(
            ReflectedType.create(int, 'int'), 'hashCode', false, false)
      ],
      methods: [
        Method.create('addDayMeal', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create('deleteDayMeal', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'updateMealServingSize',
            ReflectedType.create(null, 'void'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('Day', ReflectedType.create(Day, 'Day'),
            MethodType.constructor, false, null, false, null),
        Method.create('staticConstructor', ReflectedType.create(Day, 'Day'),
            MethodType.factory, false, null, false, Day.staticConstructor),
        Method.create('==', ReflectedType.create(bool, 'bool'),
            MethodType.operator, false, null, false, null),
        Method.create('toString', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create('copyWithDay', ReflectedType.create(Day, 'Day'),
            MethodType.normal, false, null, false, null),
        Method.create('toJson', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'toMap',
            ReflectedType.create(Map, 'Map<String, dynamic>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('fromJson', ReflectedType.create(Day, 'Day'),
            MethodType.factory, false, null, false, Day.fromJson),
        Method.create('fromMap', ReflectedType.create(Day, 'Day'),
            MethodType.factory, false, null, false, Day.fromMap)
      ],
      parent: null,
      mixins: null,
      implementations: null),
  ReflectedClass(
      name: 'DRI',
      referenceType: ReflectedType.create(DRI, 'DRI'),
      dataclassAnnotation: Annotation.create('Dataclass', [], {}),
      attributes: [
        Attribute.create('name', ReflectedType.create(String, 'String'), false,
            false, false, false, false, null),
        Attribute.create('dri', ReflectedType.create(num, 'num?'), false, false,
            false, false, false, null),
        Attribute.create('upperLimit', ReflectedType.create(num, 'num?'), false,
            false, false, false, false, null),
        Attribute.create('unit', ReflectedType.create(String, 'String'), false,
            false, false, false, false, null),
        Attribute.create('note', ReflectedType.create(String, 'String?'), false,
            false, false, false, false, null),
        Attribute.create('tracked', ReflectedType.create(bool, 'bool'), false,
            false, false, false, false, true)
      ],
      getters: [
        Getter.create(
            ReflectedType.create(int, 'int'), 'hashCode', false, false)
      ],
      methods: [
        Method.create('compare', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create('*', ReflectedType.create(DRI, 'DRI'),
            MethodType.operator, false, null, false, null),
        Method.create('/', ReflectedType.create(DRI, 'DRI'),
            MethodType.operator, false, null, false, null),
        Method.create('DRI', ReflectedType.create(DRI, 'DRI'),
            MethodType.constructor, false, null, false, null),
        Method.create('sugars', ReflectedType.create(DRI, 'DRI'),
            MethodType.factory, false, null, false, DRI.sugars),
        Method.create('toString', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create('substitutions', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create('addNote', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create('driMacro', ReflectedType.create(DRI, 'DRI'),
            MethodType.factory, false, null, false, DRI.driMacro),
        Method.create('driMicro', ReflectedType.create(DRI, 'DRI'),
            MethodType.factory, false, null, false, DRI.driMicro),
        Method.create('==', ReflectedType.create(bool, 'bool'),
            MethodType.operator, false, null, false, null),
        Method.create(
            'toMap',
            ReflectedType.create(Map, 'Map<String, dynamic>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('fromMap', ReflectedType.create(DRI, 'DRI'),
            MethodType.factory, false, null, false, DRI.fromMap),
        Method.create('copyWith', ReflectedType.create(DRI, 'DRI'),
            MethodType.normal, false, null, false, null)
      ],
      parent: null,
      mixins: null,
      implementations: null),
  ReflectedClass(
      name: 'AnthroMetrics',
      referenceType: ReflectedType.create(AnthroMetrics, 'AnthroMetrics'),
      dataclassAnnotation:
          Annotation.create('Dataclass', [], {'constructor': 'false'}),
      attributes: [
        Attribute.create('sex', ReflectedType.create(Sex, 'Sex'), false, false,
            false, false, false, null),
        Attribute.create('age', ReflectedType.create(int, 'int'), false, false,
            false, false, false, null),
        Attribute.create('weight', ReflectedType.create(int, 'int'), false,
            false, false, false, false, null),
        Attribute.create('feet', ReflectedType.create(int, 'int'), false, false,
            false, false, false, null),
        Attribute.create('inches', ReflectedType.create(int, 'int'), false,
            false, false, false, false, null),
        Attribute.create('activity', ReflectedType.create(Activity, 'Activity'),
            false, false, false, false, false, null)
      ],
      getters: [
        Getter.create(
            ReflectedType.create(dynamic, 'dynamic'), 'cm', false, false),
        Getter.create(
            ReflectedType.create(dynamic, 'dynamic'), 'kg', false, false),
        Getter.create(ReflectedType.create(Map, 'Map<String, dynamic>'),
            'attributes__', false, false),
        Getter.create(
            ReflectedType.create(int, 'int'), 'hashCode', false, false)
      ],
      methods: [
        Method.create('cm', ReflectedType.create(null, 'void'),
            MethodType.setter, false, null, false, null),
        Method.create('kg', ReflectedType.create(null, 'void'),
            MethodType.setter, false, null, false, null),
        Method.create(
            'AnthroMetrics',
            ReflectedType.create(AnthroMetrics, 'AnthroMetrics'),
            MethodType.constructor,
            false,
            null,
            false,
            null),
        Method.create(
            'staticConstructor',
            ReflectedType.create(AnthroMetrics, 'AnthroMetrics'),
            MethodType.factory,
            false,
            null,
            false,
            AnthroMetrics.staticConstructor),
        Method.create('==', ReflectedType.create(bool, 'bool'),
            MethodType.operator, false, null, false, null),
        Method.create('toString', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'copyWithAnthroMetrics',
            ReflectedType.create(AnthroMetrics, 'AnthroMetrics'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('toJson', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'toMap',
            ReflectedType.create(Map, 'Map<String, dynamic>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create(
            'fromJson',
            ReflectedType.create(AnthroMetrics, 'AnthroMetrics'),
            MethodType.factory,
            false,
            null,
            false,
            AnthroMetrics.fromJson),
        Method.create(
            'fromMap',
            ReflectedType.create(AnthroMetrics, 'AnthroMetrics'),
            MethodType.factory,
            false,
            null,
            false,
            AnthroMetrics.fromMap),
        Method.create(
            'fromMetric',
            ReflectedType.create(AnthroMetrics, 'AnthroMetrics'),
            MethodType.factory,
            false,
            null,
            false,
            AnthroMetrics.fromMetric),
        Method.create(
            'toDictForPost',
            ReflectedType.create(Map, 'Map<String, String>'),
            MethodType.normal,
            false,
            null,
            false,
            null)
      ],
      parent: null,
      mixins: null,
      implementations: null),
  ReflectedClass(
      name: 'Diet',
      referenceType: ReflectedType.create(Diet, 'Diet'),
      dataclassAnnotation:
          Annotation.create('Dataclass', [], {'constructor': 'false'}),
      attributes: [
        Attribute.create('name', ReflectedType.create(String, 'String'), false,
            false, false, false, false, null),
        Attribute.create('days', ReflectedType.create(List, 'List<Day>'), false,
            false, false, false, false, null),
        Attribute.create('dris', ReflectedType.create(DRIS, 'DRIS'), false,
            false, false, false, false, null),
        Attribute.create(
            'shoppingList',
            ReflectedType.create(Map, 'Map<String, List<MealComponent>>'),
            false,
            false,
            false,
            true,
            false,
            null)
      ],
      getters: [
        Getter.create(ReflectedType.create(Nutrients, 'Nutrients'),
            'averageNutrition', false, false),
        Getter.create(ReflectedType.create(Map, 'Map<String, dynamic>'),
            'attributes__', false, false),
        Getter.create(
            ReflectedType.create(int, 'int'), 'hashCode', false, false)
      ],
      methods: [
        Method.create('createDay', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create('removeDay', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'initShoppingList',
            ReflectedType.create(List, 'List<MealComponent>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('updateShoppingList', ReflectedType.create(null, 'void'),
            MethodType.normal, false, null, false, null),
        Method.create('Diet', ReflectedType.create(Diet, 'Diet'),
            MethodType.constructor, false, null, false, null),
        Method.create('staticConstructor', ReflectedType.create(Diet, 'Diet'),
            MethodType.factory, false, null, false, Diet.staticConstructor),
        Method.create('==', ReflectedType.create(bool, 'bool'),
            MethodType.operator, false, null, false, null),
        Method.create('toString', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create('copyWithDiet', ReflectedType.create(Diet, 'Diet'),
            MethodType.normal, false, null, false, null),
        Method.create('toJson', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'toMap',
            ReflectedType.create(Map, 'Map<String, dynamic>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('fromJson', ReflectedType.create(Diet, 'Diet'),
            MethodType.factory, false, null, false, Diet.fromJson),
        Method.create('fromMap', ReflectedType.create(Diet, 'Diet'),
            MethodType.factory, false, null, false, Diet.fromMap)
      ],
      parent: null,
      mixins: null,
      implementations: null),
  ReflectedClass(
      name: 'BaseNutrients',
      referenceType: ReflectedType.create(BaseNutrients, 'BaseNutrients'),
      dataclassAnnotation:
          Annotation.create('Dataclass', [], {'constructor': 'false'}),
      attributes: [
        Attribute.create('grams', ReflectedType.create(num, 'num'), false,
            false, false, false, false, null),
        Attribute.create(
            'nutrients',
            ReflectedType.create(Nutrients, 'Nutrients'),
            false,
            false,
            false,
            false,
            false,
            null)
      ],
      getters: [
        Getter.create(ReflectedType.create(Map, 'Map<String, dynamic>'),
            'attributes__', false, false),
        Getter.create(
            ReflectedType.create(int, 'int'), 'hashCode', false, false)
      ],
      methods: [
        Method.create(
            'BaseNutrients',
            ReflectedType.create(BaseNutrients, 'BaseNutrients'),
            MethodType.constructor,
            false,
            null,
            false,
            null),
        Method.create(
            'staticConstructor',
            ReflectedType.create(BaseNutrients, 'BaseNutrients'),
            MethodType.factory,
            false,
            null,
            false,
            BaseNutrients.staticConstructor),
        Method.create('==', ReflectedType.create(bool, 'bool'),
            MethodType.operator, false, null, false, null),
        Method.create('toString', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'copyWithBaseNutrients',
            ReflectedType.create(BaseNutrients, 'BaseNutrients'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('toJson', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'toMap',
            ReflectedType.create(Map, 'Map<String, dynamic>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create(
            'fromJson',
            ReflectedType.create(BaseNutrients, 'BaseNutrients'),
            MethodType.factory,
            false,
            null,
            false,
            BaseNutrients.fromJson),
        Method.create(
            'fromMap',
            ReflectedType.create(BaseNutrients, 'BaseNutrients'),
            MethodType.factory,
            false,
            null,
            false,
            BaseNutrients.fromMap)
      ],
      parent: null,
      mixins: null,
      implementations: null),
  ReflectedClass(
      name: 'Meal',
      referenceType: ReflectedType.create(Meal, 'Meal'),
      dataclassAnnotation: Annotation.create(
          'Dataclass', [], {'constructor': 'false', 'attributes': 'false'}),
      attributes: [
        Attribute.create('name', ReflectedType.create(String, 'String'), false,
            false, false, false, false, null, '+++'),
        Attribute.create(
            'ingredients',
            ReflectedType.create(List, 'List<MealComponent>'),
            false,
            false,
            false,
            false,
            false,
            null),
        Attribute.create('servings', ReflectedType.create(int, 'int'), false,
            false, false, false, false, null),
        Attribute.create('isSubRecipe', ReflectedType.create(bool, 'bool'),
            false, false, false, false, false, null),
        Attribute.create('photo', ReflectedType.create(Uri, 'Uri?'), false,
            false, false, false, false, null),
        Attribute.create('notes', ReflectedType.create(String, 'String'), false,
            false, false, false, false, '')
      ],
      getters: [
        Getter.create(ReflectedType.create(Map, 'Map<String, dynamic>'),
            'attributes__', false, false),
        Getter.create(
            ReflectedType.create(int, 'int'), 'hashCode', false, false)
      ],
      methods: [
        Method.create(
            'baseIngredients',
            ReflectedType.create(List, 'List<MealComponent>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('Meal', ReflectedType.create(Meal, 'Meal'),
            MethodType.constructor, false, null, false, null),
        Method.create('staticConstructor', ReflectedType.create(Meal, 'Meal'),
            MethodType.factory, false, null, false, Meal.staticConstructor),
        Method.create('==', ReflectedType.create(bool, 'bool'),
            MethodType.operator, false, null, false, null),
        Method.create('toString', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create('copyWithMeal', ReflectedType.create(Meal, 'Meal'),
            MethodType.normal, false, null, false, null),
        Method.create('toJson', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'toMap',
            ReflectedType.create(Map, 'Map<String, dynamic>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('fromJson', ReflectedType.create(Meal, 'Meal'),
            MethodType.factory, false, null, false, Meal.fromJson),
        Method.create('fromMap', ReflectedType.create(Meal, 'Meal'),
            MethodType.factory, false, null, false, Meal.fromMap)
      ],
      parent: MealComponentFactory,
      mixins: null,
      implementations: null),
  ReflectedClass(
      name: 'DRIS',
      referenceType: ReflectedType.create(DRIS, 'DRIS'),
      dataclassAnnotation:
          Annotation.create('Dataclass', [], {'constructor': 'false'}),
      attributes: [
        Attribute.create('calcium', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('carbohydrate', ReflectedType.create(DRI, 'DRI'),
            false, false, false, false, false, null),
        Attribute.create('cholesterol', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('calories', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('totalFat', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('iron', ReflectedType.create(DRI, 'DRI'), false, false,
            false, false, false, null),
        Attribute.create('fiber', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('potassium', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('sodium', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('protein', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('sugars', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('choline', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('copper', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('ala', ReflectedType.create(DRI, 'DRI'), false, false,
            false, false, false, null),
        Attribute.create('linoleicAcid', ReflectedType.create(DRI, 'DRI'),
            false, false, false, false, false, null),
        Attribute.create('epa', ReflectedType.create(DRI, 'DRI'), false, false,
            false, false, false, null),
        Attribute.create('dpa', ReflectedType.create(DRI, 'DRI'), false, false,
            false, false, false, null),
        Attribute.create('dha', ReflectedType.create(DRI, 'DRI'), false, false,
            false, false, false, null),
        Attribute.create('folate', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('magnesium', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('manganese', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('niacin', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('phosphorus', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('pantothenicAcid', ReflectedType.create(DRI, 'DRI'),
            false, false, false, false, false, null),
        Attribute.create('riboflavin', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('selenium', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('thiamin', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('vitaminE', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('vitaminA', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('vitaminB12', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('vitaminB6', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('vitaminC', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('vitaminD', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('vitaminK', ReflectedType.create(DRI, 'DRI'), false,
            false, false, false, false, null),
        Attribute.create('zinc', ReflectedType.create(DRI, 'DRI'), false, false,
            false, false, false, null),
        Attribute.create('transFat', ReflectedType.create(DRI, 'DRI'), false,
            false, false, true, false, null),
        Attribute.create('unsaturatedFat', ReflectedType.create(DRI, 'DRI'),
            false, false, false, true, false, null),
        Attribute.create('saturatedFat', ReflectedType.create(DRI, 'DRI'),
            false, false, false, true, false, null),
        Attribute.create(
            'representor',
            ReflectedType.create(Map, 'Map<String, String>'),
            false,
            true,
            false,
            false,
            false,
            DRIS.representor)
      ],
      getters: [
        Getter.create(ReflectedType.create(Map, 'Map<String, dynamic>'),
            'attributes__', false, false),
        Getter.create(
            ReflectedType.create(int, 'int'), 'hashCode', false, false)
      ],
      methods: [
        Method.create('fromPreparedList', ReflectedType.create(DRIS, 'DRIS'),
            MethodType.factory, false, null, false, DRIS.fromPreparedList),
        Method.create('*', ReflectedType.create(DRIS, 'DRIS'),
            MethodType.operator, false, null, false, null),
        Method.create('/', ReflectedType.create(DRIS, 'DRIS'),
            MethodType.operator, false, null, false, null),
        Method.create('fromAPI', ReflectedType.create(Future, 'Future<DRIS>'),
            MethodType.normal, true, null, false, DRIS.fromAPI),
        Method.create(
            'comparator',
            ReflectedType.create(Map, 'Map<String, List>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('DRIS', ReflectedType.create(DRIS, 'DRIS'),
            MethodType.constructor, false, null, false, null),
        Method.create('staticConstructor', ReflectedType.create(DRIS, 'DRIS'),
            MethodType.factory, false, null, false, DRIS.staticConstructor),
        Method.create('==', ReflectedType.create(bool, 'bool'),
            MethodType.operator, false, null, false, null),
        Method.create('toString', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create('copyWithDRIS', ReflectedType.create(DRIS, 'DRIS'),
            MethodType.normal, false, null, false, null),
        Method.create('toJson', ReflectedType.create(String, 'String'),
            MethodType.normal, false, null, false, null),
        Method.create(
            'toMap',
            ReflectedType.create(Map, 'Map<String, dynamic>'),
            MethodType.normal,
            false,
            null,
            false,
            null),
        Method.create('fromJson', ReflectedType.create(DRIS, 'DRIS'),
            MethodType.factory, false, null, false, DRIS.fromJson),
        Method.create('fromMap', ReflectedType.create(DRIS, 'DRIS'),
            MethodType.factory, false, null, false, DRIS.fromMap)
      ],
      parent: null,
      mixins: null,
      implementations: null)
];
List<EnumExtension> enumExtensions = [
  EnumExtension(
      name: 'Sex',
      referenceType: ReflectedType.create(Sex, "Sex"),
      options: [
        'M',
        'F'
      ],
      methods: [
        Method.create("fromMap", ReflectedType.create(Sex, "Sex"),
            MethodType.factory, false, null, false, (Map map) {
          if (map['value'] == 'Sex.M') {
            return Sex.M;
          }
          if (map['value'] == 'Sex.F') {
            return Sex.F;
          }
          throw Exception("Enum Sex can not instantiate from map $map");
        }),
      ]),
  EnumExtension(
      name: 'Activity',
      referenceType: ReflectedType.create(Activity, "Activity"),
      options: [
        'Sedentary',
        'Low_Active',
        'Active',
        'Very_Active'
      ],
      methods: [
        Method.create("fromMap", ReflectedType.create(Activity, "Activity"),
            MethodType.factory, false, null, false, (Map map) {
          if (map['value'] == 'Activity.Sedentary') {
            return Activity.Sedentary;
          }
          if (map['value'] == 'Activity.Low_Active') {
            return Activity.Low_Active;
          }
          if (map['value'] == 'Activity.Active') {
            return Activity.Active;
          }
          if (map['value'] == 'Activity.Very_Active') {
            return Activity.Very_Active;
          }
          throw Exception("Enum Activity can not instantiate from map $map");
        }),
      ]),
  EnumExtension(
      name: 'Measure',
      referenceType: ReflectedType.create(Measure, "Measure"),
      options: [
        'metric',
        'imperial'
      ],
      methods: [
        Method.create("fromMap", ReflectedType.create(Measure, "Measure"),
            MethodType.factory, false, null, false, (Map map) {
          if (map['value'] == 'Measure.metric') {
            return Measure.metric;
          }
          if (map['value'] == 'Measure.imperial') {
            return Measure.imperial;
          }
          throw Exception("Enum Measure can not instantiate from map $map");
        }),
      ]),
  EnumExtension(
      name: 'PopUpOptions',
      referenceType: ReflectedType.create(PopUpOptions, "PopUpOptions"),
      options: [
        'edit',
        'delete',
        'duplicate'
      ],
      methods: [
        Method.create(
            "fromMap",
            ReflectedType.create(PopUpOptions, "PopUpOptions"),
            MethodType.factory,
            false,
            null,
            false, (Map map) {
          if (map['value'] == 'PopUpOptions.edit') {
            return PopUpOptions.edit;
          }
          if (map['value'] == 'PopUpOptions.delete') {
            return PopUpOptions.delete;
          }
          if (map['value'] == 'PopUpOptions.duplicate') {
            return PopUpOptions.duplicate;
          }
          throw Exception(
              "Enum PopUpOptions can not instantiate from map $map");
        }),
      ]),
  EnumExtension(
      name: 'IngredientSource',
      referenceType: ReflectedType.create(IngredientSource, "IngredientSource"),
      options: [
        'string',
        'upc',
        'custom'
      ],
      methods: [
        Method.create(
            "fromMap",
            ReflectedType.create(IngredientSource, "IngredientSource"),
            MethodType.factory,
            false,
            null,
            false, (Map map) {
          if (map['value'] == 'IngredientSource.string') {
            return IngredientSource.string;
          }
          if (map['value'] == 'IngredientSource.upc') {
            return IngredientSource.upc;
          }
          if (map['value'] == 'IngredientSource.custom') {
            return IngredientSource.custom;
          }
          throw Exception(
              "Enum IngredientSource can not instantiate from map $map");
        }),
      ])
];

Map<String, ReflectedClass> str2dataclasses = {
  for (ReflectedClass x in dataclasses) x.name: x
};
Map<Type, ReflectedClass> type2dataclasses = {
  for (ReflectedClass x in dataclasses) x.referenceType.referenceType!: x
};

Map<String, EnumExtension> str2enumExtensions = {
  for (EnumExtension x in enumExtensions) x.name: x
};
Map<Type, EnumExtension> type2enumExtensions = {
  for (EnumExtension x in enumExtensions) x.referenceType.referenceType!: x
};

// All together

List<SupportedClasses> reflectedClasses = [
  ...dataclasses,
  ...supportedDefaults,
  ...enumExtensions
];
Map<String, SupportedClasses> str2reflection = {
  ...str2dataclasses,
  ...str2defaults,
  ...str2enumExtensions
};
Map<Type, SupportedClasses> type2reflection = {
  ...type2dataclasses,
  ...type2defaults,
  ...type2enumExtensions
};

// Deserialize JSON

dejsonify(thing) {
  // Map or Recognized
  if (thing is Map) {
    // Recognized
    if (str2reflection[thing['__type']]?.fromMap != null) {
      return str2reflection[thing['__type']]!.fromMap!(thing);
    }
    // Map
    return dejsonifyMap(thing);
  }
  // List
  if (thing is List) {
    return dejsonifyList(thing);
  }
  // Json safe type
  return thing;
}

List dejsonifyList(List list) {
  return list.map((e) => dejsonify(e)).toList();
}

Map dejsonifyMap(Map map) {
  return Map.from(
      map.map((key, value) => MapEntry(dejsonify(key), dejsonify(value))));
}

// Serialize JSON

jsonify(thing) {
  try {
    return thing.toMap();
  } on NoSuchMethodError {
    if (isJsonSafe(thing)) {
      return thing;
    } else if (supportedTypeToMap(thing) != null) {
      return supportedTypeToMap(thing);
    } else if (thing is Iterable && !isMap(thing)) {
      return nestedJsonList(thing);
    } else if (isMap(thing)) {
      return nestedJsonMap(thing);
    } else {
      throw Exception('Error on handling $thing since ${thing.runtimeType} '
          'is not a base class or does not have a toJson() method');
    }
  }
}

List nestedJsonList(Iterable iter) {
  List l = [];
  for (var thing in iter) {
    l.add(jsonify(thing));
  }
  return l;
}

Map nestedJsonMap(mapLikeThing) {
  Map m = {};
  var key;
  var value;

  for (MapEntry mapEntry in mapLikeThing.entries) {
    key = jsonify(mapEntry.key);
    value = jsonify(mapEntry.value);
    m[key] = value;
  }

  return m;
}
