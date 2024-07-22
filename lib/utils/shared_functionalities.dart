import 'dart:async';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:hive/hive.dart';
import 'package:diet_planner/blocs/micro_blocs/saver.dart';
import 'package:diet_planner/domain.dart';
import 'package:lecle_downloads_path_provider/lecle_downloads_path_provider.dart';
import 'package:diet_planner/mydataclasses/metadata.dart';
import 'package:diet_planner/utils.dart';
import 'package:path_provider/path_provider.dart';

Future<File> dataFile() async {
  final appDocumentDir = await getApplicationDocumentsDirectory();
  final path = appDocumentDir.path;
  return File('$path/data.json');
}

Future<void> saveApp(App app) async {
  final box = await Hive.openBox('master');
  // Perform read/write operations on the box
  box.put('app', app.toJson());
  // await box.close();
}

Future<void> wasThereEverHive(List thing) async {
  BackgroundIsolateBinaryMessenger.ensureInitialized(thing[1]);

  final file = await dataFile();
  if (file.existsSync()) {
    file.deleteSync();
  }
  file.writeAsStringSync(thing[0].toJson());
}

Future<App?> loadApp() async {
  final file = await dataFile();
  if (file.existsSync()) {
    try {
      final json = file.readAsStringSync();
      return App.fromJson(json);
    } on Exception catch (_) {
      print('why');
      // pass
    }
  }
  final boxExists = await Hive.boxExists('master');
  final facturedLoading = await Hive.boxExists('ingredients') ||
      await Hive.boxExists('meals') ||
      await Hive.boxExists('diets');
  if (facturedLoading) {
    final masterBox = await Hive.openBox('master');
    final ingredientsBox = await Hive.openBox('ingredients');
    final mealsBox = await Hive.openBox('meals');
    final dietsBox = await Hive.openBox('diets');
    try {
      return App(
          settings: Settings.fromJson(masterBox.get('settings')),
          diets: mapName(sortByOtherList<Diet>(
              instantiateAllDCFromBox(dietsBox),
              masterBox.get('diets order'),
              (Diet obj) => obj.name)),
          meals: instantiateAllDCMap(mealsBox),
          baseIngredients: instantiateAllDCMap(ingredientsBox));
    } catch (e) {
      //pass
      // print(e);
    }
  }
  if (boxExists) {
    try {
      final box = await Hive.openBox('master');
      final json = box.get('app');
      // await box.close();
      final result = App.fromJson(json);
      fracturedSaveAll(result);
      return result;
    } catch (e) {
      return null;
    }
  } else {
    return null;
  }
}

void factoryResetApp() async {
  final box = await Hive.openBox('master');
  final box1 = await Hive.openBox('meals');
  final box2 = await Hive.openBox('ingredients');
  final box3 = await Hive.openBox('diets');
  box.deleteFromDisk();
  box1.deleteFromDisk();
  box2.deleteFromDisk();
  box3.deleteFromDisk();
  final file = await dataFile();
  if (file.existsSync()) {
    file.deleteSync();
  }
}

Future<void> saveAppBackupMobile({String? fileName, required App app}) async {
  fileName ??= 'nut_app_backup.json';
  // Get the downloads directory
  Directory downloadsDirectory = (await DownloadsPath.downloadsDirectory())!;

  File file = File('${downloadsDirectory.path}/${(fileName)}.json');

  file.writeAsStringSync(app.toJson());
}

void saveMeal(Meal meal) async {
  final box = await Hive.openBox('meals');
  box.put(meal.name, meal.toJson());
}

void deleteMealFromSave(Meal meal) async {
  final box = await Hive.openBox('meals');
  box.delete(meal.name);
}

void saveIngredient(Ingredient ingredient) async {
  final box = await Hive.openBox('ingredients');
  box.put(ingredient.name, ingredient.toJson());
}

void deleteIngredientFromSave(Ingredient ingredient) async {
  final box = await Hive.openBox('ingredients');
  box.delete(ingredient.name);
}

class Saver {
  static Saver? _instance;
  bool isSaving = false;
  final SaverBloc saverBloc;
  final RootIsolateToken root;

  // Private constructor
  Saver._(this.saverBloc, this.root);

  static messageIsApp(String message) => message == 'app';
  static messageIsDiet(String message) => message.contains(':');

  factory Saver.init(SaverBloc saverBloc, RootIsolateToken root) {
    if (_instance == null) {
      _instance = Saver._(saverBloc, root);
      return _instance!;
    }
    throw Exception('Saver instance already initialized');
  }

  factory Saver() {
    // _instance ??= Saver._();
    return _instance!;
  }
  Future<bool> app(App app) async {
    if (isSaving) {
      return false;
    } else {
      isSaving = true;
      compute(wasThereEverHive, [app, root]).whenComplete(() {
        isSaving = false;
        saverBloc.add(SavedApp());
      });
      return true;
    }
  }

  Future<bool> diet(Diet diet) async {
    if (isSaving) {
      return false;
    } else {
      isSaving = true;
      compute(saveDiet, diet).whenComplete(() {
        isSaving = false;
        saverBloc.add(SavedDiet('Diet: ${diet.name}'));
      });
      return true;
    }
  }
}

Future<void> saveDiet(Diet diet) async {
  final box = await Hive.openBox('diets');
  box.put(diet.name, diet.toJson());
}

void deleteDietFromSave(Diet diet) async {
  final box = await Hive.openBox('diets');
  box.delete(diet.name);
}

void saveSettings(Settings settings) async {
  final box = await Hive.openBox('master');
  box.put('settings', settings.toJson());
}

Future<void> saveDietsOrder(Iterable<Diet> diets) async {
  final box = await Hive.openBox('master');
  box.put('diets order', diets.map((e) => e.name).toList());
}

Future<void> fracturedSaveAll(App app) async {
  saveDietsOrder(app.diets.values);
  saveSettings(app.settings);
  for (Ingredient ing in app.baseIngredients.values) {
    saveIngredient(ing);
  }
  for (Meal meal in app.meals.values) {
    saveMeal(meal);
  }
  for (Diet diet in app.diets.values) {
    saveDiet(diet);
  }
}

List<T> instantiateAllDCFromBox<T>(Box box) {
  final result = <T>[];
  final type = T.toString();
  for (String value in box.values) {
    result.add(str2reflection[type]!.fromJson!(value));
  }
  return result;
}

Map<String, K> mapName<K>(Iterable<K> list) =>
    {for (dynamic k in list) k.name: k as K};

Map<String, T> instantiateAllDCMap<T>(Box box) {
  return mapName<T>(sorter(instantiateAllDCFromBox<T>(box), (T thing) {
    dynamic temp = thing;
    return (temp.name as String).toLowerCase();
  }));
}

List<String> boxNames = ['master', 'meals', 'diets', 'ingredients'];
List<String> masterBoxValues = ['diets order', 'settings', 'app'];
