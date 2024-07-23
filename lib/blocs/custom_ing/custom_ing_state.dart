part of 'custom_ing_bloc.dart';

bool invalidateNum(String s) => s.isEmpty || s == '.';

class CustomIngState {
  String baseGrams;
  String name;
  List<MapEntry<String, String>> altMeasures;
  Map<String, String> nutrientFields;
  Uri? image;
  Ingredient? refIngredient;

  factory CustomIngState.initial() => CustomIngState(
      baseGrams: '',
      name: '',
      altMeasures: [const MapEntry('', '')],
      nutrientFields: {for (Nutrient nut in nutList) nut.name: '0'});

  factory CustomIngState.fromIngredient(Ingredient ref) {
    final reNutList =
        List<Nutrient>.from(ref.baseNutrient.nutrients.attributes__.values);
    return CustomIngState(
        baseGrams: ref.baseNutrient.grams.toString(),
        name: ref.name,
        altMeasures: ref.altMeasures2grams
            .map((key, value) => MapEntry(key, value.toString()))
            .entries
            .toList(),
        nutrientFields: Map<String, String>.fromEntries(reNutList.map((value) =>
            MapEntry<String, String>(value.name, value.value.toString()))),
        refIngredient: ref,
        image: ref.photo);
  }

  bool isInvalid() {
    if (baseGrams.isEmpty || name.isEmpty || baseGrams == '.') {
      return true;
    }
    for (MapEntry<String, String> alt_measure in altMeasures) {
      if (alt_measure.key == '') {
        continue;
      }
      if (alt_measure.key.isEmpty ||
          alt_measure.value.isEmpty ||
          alt_measure.value == '.') {
        return true;
      }
    }
    for (String nutField in nutrientFields.values) {
      if (nutField.isEmpty || nutField == '.') {
        return true;
      }
    }
    return false;
  }

  bool _saveFile() {
    // if (image == null){return false;}
    if (image == null) {
      return false;
    }
    if (refIngredient?.photo == image) {
      return false;
    }
    if (image!.scheme == 'file') {
      return true;
    }
    return false;
  }

  Future<Ingredient> toIngredient() async {
    final transformedAlts = Map<String, num>.fromEntries(altMeasures
        .where((element) => element.key != '')
        .map((e) => MapEntry<String, num>(e.key, fixDecimal(e.value)!)));
    Uri? finalImage;
    if (_saveFile()) {
      finalImage = await saveImage(image!.path);
    } else {
      finalImage = image;
    }
    // transformedAlts.remove('');
    Ingredient result = Ingredient(
        name: name,
        baseNutrient: BaseNutrients(
            grams: fixDecimal(baseGrams)!,
            nutrients: Nutrients.fromValues(
                calcium: fixDecimal(nutrientFields['Calcium']!)!,
                carbohydrate: fixDecimal(nutrientFields['Carbohydrate']!)!,
                cholesterol: fixDecimal(nutrientFields['Cholesterol']!)!,
                calories: fixDecimal(nutrientFields['Calories']!)!,
                saturatedFat: fixDecimal(nutrientFields['SaturatedFat']!)!,
                totalFat: fixDecimal(nutrientFields['TotalFat']!)!,
                transFat: fixDecimal(nutrientFields['TransFat']!)!,
                iron: fixDecimal(nutrientFields['Iron']!)!,
                fiber: fixDecimal(nutrientFields['Fiber']!)!,
                potassium: fixDecimal(nutrientFields['Potassium']!)!,
                sodium: fixDecimal(nutrientFields['Sodium']!)!,
                protein: fixDecimal(nutrientFields['Protein']!)!,
                sugars: fixDecimal(nutrientFields['Sugars']!)!,
                choline: fixDecimal(nutrientFields['Choline']!)!,
                copper: fixDecimal(nutrientFields['Copper']!)!,
                ala: fixDecimal(nutrientFields['ALA']!)!,
                linoleicAcid: fixDecimal(nutrientFields['LinoleicAcid']!)!,
                epa: fixDecimal(nutrientFields['EPA']!)!,
                dpa: fixDecimal(nutrientFields['DPA']!)!,
                dha: fixDecimal(nutrientFields['DHA']!)!,
                folate: fixDecimal(nutrientFields['Folate']!)!,
                magnesium: fixDecimal(nutrientFields['Magnesium']!)!,
                manganese: fixDecimal(nutrientFields['Manganese']!)!,
                niacin: fixDecimal(nutrientFields['Niacin']!)!,
                phosphorus: fixDecimal(nutrientFields['Phosphorus']!)!,
                pantothenicAcid:
                    fixDecimal(nutrientFields['PantothenicAcid']!)!,
                riboflavin: fixDecimal(nutrientFields['Riboflavin']!)!,
                selenium: fixDecimal(nutrientFields['Selenium']!)!,
                thiamin: fixDecimal(nutrientFields['Thiamin']!)!,
                vitaminE: fixDecimal(nutrientFields['VitaminE']!)!,
                vitaminA: fixDecimal(nutrientFields['VitaminA']!)!,
                vitaminB12: fixDecimal(nutrientFields['VitaminB12']!)!,
                vitaminB6: fixDecimal(nutrientFields['VitaminB6']!)!,
                vitaminC: fixDecimal(nutrientFields['VitaminC']!)!,
                vitaminD: fixDecimal(nutrientFields['VitaminD']!)!,
                vitaminK: fixDecimal(nutrientFields['VitaminK']!)!,
                zinc: fixDecimal(nutrientFields['Zinc']!)!)),
        altMeasures2grams: transformedAlts,
        source: IngredientSource.custom,
        photo: finalImage);
    return result;
  }

  CustomIngState(
      {required this.baseGrams,
      required this.name,
      required this.altMeasures,
      required this.nutrientFields,
      this.image,
      this.refIngredient});

  CustomIngState copyWith(
      {String? baseGrams_,
      String? name_,
      List<MapEntry<String, String>>? altMeasures_,
      Map<String, String>? nutrientFields_,
      Uri? img,
      Ingredient? ref}) {
    return CustomIngState(
        baseGrams: baseGrams_ ?? baseGrams,
        name: name_ ?? name,
        altMeasures: altMeasures_ ?? altMeasures,
        nutrientFields: nutrientFields_ ?? nutrientFields,
        refIngredient: ref ?? refIngredient,
        image: img ?? image);
  }

  factory CustomIngState.fromState(CustomIngState state) {
    return CustomIngState(
        baseGrams: state.baseGrams,
        name: state.name,
        altMeasures: state.altMeasures,
        nutrientFields: state.nutrientFields,
        refIngredient: state.refIngredient,
        image: state.image);
  }
}

class CustomIngErrors extends CustomIngState {
  factory CustomIngErrors.fromState(CustomIngState state) {
    return CustomIngErrors(
        baseGrams: state.baseGrams,
        name: state.name,
        altMeasures: state.altMeasures,
        nutrientFields: state.nutrientFields,
        refIngredient: state.refIngredient,
        image: state.image);
  }

  CustomIngErrors(
      {required super.baseGrams,
      required super.name,
      required super.altMeasures,
      required super.nutrientFields,
      super.image,
      super.refIngredient});
}

class CustomIngAddedPhoto extends CustomIngState {
  factory CustomIngAddedPhoto.fromState(CustomIngState state) {
    return CustomIngAddedPhoto(
        baseGrams: state.baseGrams,
        name: state.name,
        altMeasures: state.altMeasures,
        nutrientFields: state.nutrientFields,
        refIngredient: state.refIngredient,
        image: state.image);
  }

  CustomIngAddedPhoto(
      {required super.baseGrams,
      required super.name,
      required super.altMeasures,
      required super.nutrientFields,
      super.image,
      super.refIngredient});
}

class CustomIngSuccess extends CustomIngState {
  Ingredient ingredient;

  factory CustomIngSuccess.fromState(
      CustomIngState state, Ingredient ingredient) {
    return CustomIngSuccess(
        baseGrams: state.baseGrams,
        name: state.name,
        altMeasures: state.altMeasures,
        nutrientFields: state.nutrientFields,
        refIngredient: state.refIngredient,
        image: state.image,
        ingredient: ingredient);
  }

  CustomIngSuccess(
      {required super.baseGrams,
      required super.name,
      required super.altMeasures,
      required super.nutrientFields,
      super.image,
      super.refIngredient,
      required this.ingredient});
}

// class CustomIngInitial extends CustomIngState {}