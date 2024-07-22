import 'dart:convert';
import 'package:ari_utils/ari_utils.dart';
import 'package:dataclasses/dataclasses.dart';
import 'package:diet_planner/api/nutritionix.dart';
import 'package:diet_planner/domain.dart';
import 'package:diet_planner/api/dri.dart';
import 'package:diet_planner/mydataclasses/metadata.dart';
import 'package:diet_planner/utils/utils.dart';

/// Data carriers (Nutrients and DRIs)

@Dataclass(constructor: false, copyWith: false, toStr: false)
class Nutrient {
  final num value;
  final String unit;
  final String name;

  bool checkIfSame(Nutrient other) => name == other.name;

  void error(Nutrient other) {
    throw Exception('Can\'t operate on $name with ${other.name} as they are'
        'not the same nutrient');
  }

  void errorCheck(Nutrient other) {
    if (!checkIfSame(other)) {
      error(other);
    }
  }

  Nutrient operator +(Nutrient other) {
    errorCheck(other);
    return copyWith(value + other.value);
  }

  Nutrient operator -(Nutrient other) {
    errorCheck(other);
    return copyWith(value - other.value);
  }

  Nutrient operator *(num other) {
    return copyWith(value * other);
  }

  Nutrient operator /(num other) {
    return copyWith(value / other);
  }

  //<editor-fold desc="Custom Data Methods and Constructors">

  @override
  String toString() => '$name(value: $value, unit: $unit)';

  Nutrient copyWith(num? value) =>
      Nutrient(value: value ?? this.value, unit: unit, name: name);

  Nutrient({
    required this.value,
    required this.unit,
    required this.name,
  });

  Nutrient.Calcium(this.value, {this.unit = "mg", this.name = "Calcium"});

  Nutrient.Carbohydrate(this.value,
      {this.unit = "g", this.name = "Carbohydrate"});

  Nutrient.Cholesterol(this.value,
      {this.unit = "mg", this.name = "Cholesterol"});

  Nutrient.Calories(this.value, {this.unit = "kcal", this.name = "Calories"});

  Nutrient.SaturatedFat(this.value,
      {this.unit = "g", this.name = "SaturatedFat"});

  Nutrient.TotalFat(this.value, {this.unit = "g", this.name = "TotalFat"});

  Nutrient.TransFat(this.value, {this.unit = "g", this.name = "TransFat"});

  Nutrient.Iron(this.value, {this.unit = "mg", this.name = "Iron"});

  Nutrient.Fiber(this.value, {this.unit = "g", this.name = "Fiber"});

  Nutrient.Potassium(this.value, {this.unit = "mg", this.name = "Potassium"});

  Nutrient.Sodium(this.value, {this.unit = "mg", this.name = "Sodium"});

  Nutrient.Protein(this.value, {this.unit = "g", this.name = "Protein"});

  Nutrient.Sugars(this.value, {this.unit = "g", this.name = "Sugars"});

  Nutrient.Choline(this.value, {this.unit = "mg", this.name = "Choline"});

  Nutrient.Copper(this.value, {this.unit = "mg", this.name = "Copper"});

  Nutrient.ALA(this.value, {this.unit = "g", this.name = "ALA"});

  Nutrient.LinoleicAcid(this.value,
      {this.unit = "g", this.name = "LinoleicAcid"});

  Nutrient.EPA(this.value, {this.unit = "g", this.name = "EPA"});

  Nutrient.DPA(this.value, {this.unit = "g", this.name = "DPA"});

  Nutrient.DHA(this.value, {this.unit = "g", this.name = "DHA"});

  Nutrient.Folate(this.value, {this.unit = "µg", this.name = "Folate"});

  Nutrient.Magnesium(this.value, {this.unit = "mg", this.name = "Magnesium"});

  Nutrient.Manganese(this.value, {this.unit = "mg", this.name = "Manganese"});

  Nutrient.Niacin(this.value, {this.unit = "mg", this.name = "Niacin"});

  Nutrient.Phosphorus(this.value, {this.unit = "mg", this.name = "Phosphorus"});

  Nutrient.PantothenicAcid(this.value,
      {this.unit = "mg", this.name = "PantothenicAcid"});

  Nutrient.Riboflavin(this.value, {this.unit = "mg", this.name = "Riboflavin"});

  Nutrient.Selenium(this.value, {this.unit = "µg", this.name = "Selenium"});

  Nutrient.Thiamin(this.value, {this.unit = "mg", this.name = "Thiamin"});

  Nutrient.VitaminE(this.value, {this.unit = "mg", this.name = "VitaminE"});

  Nutrient.VitaminA(this.value, {this.unit = "µg", this.name = "VitaminA"});

  Nutrient.VitaminB12(this.value, {this.unit = "µg", this.name = "VitaminB12"});

  Nutrient.VitaminB6(this.value, {this.unit = "mg", this.name = "VitaminB6"});

  Nutrient.VitaminC(this.value, {this.unit = "mg", this.name = "VitaminC"});

  Nutrient.VitaminD(this.value, {this.unit = "µg", this.name = "VitaminD"});

  Nutrient.VitaminK(this.value, {this.unit = "µg", this.name = "VitaminK"});

  Nutrient.Zinc(this.value, {this.unit = "mg", this.name = "Zinc"});

  Nutrient.UnsaturatedFat(this.value,
      {this.unit = 'g', this.name = 'UnstauratedFat'});

//</editor-fold>

  // <editor-fold desc="Dataclass Section">
  @Generate()
  // <Dataclass>

  factory Nutrient.staticConstructor({
    required value,
    required unit,
    required name,
  }) =>
      Nutrient(value: value, unit: unit, name: name);

  Map<String, dynamic> get attributes__ =>
      {"value": value, "unit": unit, "name": name};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Nutrient &&
          runtimeType == other.runtimeType &&
          equals(value, other.value) &&
          equals(unit, other.unit) &&
          equals(name, other.name));

  @override
  int get hashCode => value.hashCode ^ unit.hashCode ^ name.hashCode;

  String toJson() => jsonEncode(toMap());
  Map<String, dynamic> toMap() =>
      {'__type': 'Nutrient', ...nestedJsonMap(attributes__)};

  factory Nutrient.fromJson(String json) => Nutrient.fromMap(jsonDecode(json));

  factory Nutrient.fromMap(Map map) {
    num value = map['value'];
    String unit = map['unit'];
    String name = map['name'];

    // No casting

    return Nutrient(value: value, unit: unit, name: name);
  }
  // </Dataclass>

// </editor-fold>
}

@Dataclass()
class Nutrients {
  // List off nutrients here
  final Nutrient calcium;
  final Nutrient carbohydrate;
  final Nutrient cholesterol;
  final Nutrient calories;
  final Nutrient saturatedFat;
  final Nutrient totalFat;
  final Nutrient transFat;
  final Nutrient iron;
  final Nutrient fiber;
  final Nutrient potassium;
  final Nutrient sodium;
  final Nutrient protein;
  final Nutrient sugars;
  final Nutrient choline;
  final Nutrient copper;
  final Nutrient ala;
  final Nutrient linoleicAcid;
  final Nutrient epa;
  final Nutrient dpa;
  final Nutrient dha;
  final Nutrient folate;
  final Nutrient magnesium;
  final Nutrient manganese;
  final Nutrient niacin;
  final Nutrient phosphorus;
  final Nutrient pantothenicAcid;
  final Nutrient riboflavin;
  final Nutrient selenium;
  final Nutrient thiamin;
  final Nutrient vitaminE;
  final Nutrient vitaminA;
  final Nutrient vitaminB12;
  final Nutrient vitaminB6;
  final Nutrient vitaminC;
  final Nutrient vitaminD;
  final Nutrient vitaminK;
  final Nutrient zinc;
  late final Nutrient unsaturatedFat;

  Nutrients operator +(Nutrients other) => Nutrients(
        calcium: Nutrient.Calcium(calcium.value + other.calcium.value),
        carbohydrate: Nutrient.Carbohydrate(
            carbohydrate.value + other.carbohydrate.value),
        cholesterol:
            Nutrient.Cholesterol(cholesterol.value + other.cholesterol.value),
        calories: Nutrient.Calories(calories.value + other.calories.value),
        saturatedFat: Nutrient.SaturatedFat(
            saturatedFat.value + other.saturatedFat.value),
        totalFat: Nutrient.TotalFat(totalFat.value + other.totalFat.value),
        transFat: Nutrient.TransFat(transFat.value + other.transFat.value),
        iron: Nutrient.Iron(iron.value + other.iron.value),
        fiber: Nutrient.Fiber(fiber.value + other.fiber.value),
        potassium: Nutrient.Potassium(potassium.value + other.potassium.value),
        sodium: Nutrient.Sodium(sodium.value + other.sodium.value),
        protein: Nutrient.Protein(protein.value + other.protein.value),
        sugars: Nutrient.Sugars(sugars.value + other.sugars.value),
        choline: Nutrient.Choline(choline.value + other.choline.value),
        copper: Nutrient.Copper(copper.value + other.copper.value),
        ala: Nutrient.ALA(ala.value + other.ala.value),
        linoleicAcid: Nutrient.LinoleicAcid(
            linoleicAcid.value + other.linoleicAcid.value),
        epa: Nutrient.EPA(epa.value + other.epa.value),
        dpa: Nutrient.DPA(dpa.value + other.dpa.value),
        dha: Nutrient.DHA(dha.value + other.dha.value),
        folate: Nutrient.Folate(folate.value + other.folate.value),
        magnesium: Nutrient.Magnesium(magnesium.value + other.magnesium.value),
        manganese: Nutrient.Manganese(manganese.value + other.manganese.value),
        niacin: Nutrient.Niacin(niacin.value + other.niacin.value),
        phosphorus:
            Nutrient.Phosphorus(phosphorus.value + other.phosphorus.value),
        pantothenicAcid: Nutrient.PantothenicAcid(
            pantothenicAcid.value + other.pantothenicAcid.value),
        riboflavin:
            Nutrient.Riboflavin(riboflavin.value + other.riboflavin.value),
        selenium: Nutrient.Selenium(selenium.value + other.selenium.value),
        thiamin: Nutrient.Thiamin(thiamin.value + other.thiamin.value),
        vitaminE: Nutrient.VitaminE(vitaminE.value + other.vitaminE.value),
        vitaminA: Nutrient.VitaminA(vitaminA.value + other.vitaminA.value),
        vitaminB12:
            Nutrient.VitaminB12(vitaminB12.value + other.vitaminB12.value),
        vitaminB6: Nutrient.VitaminB6(vitaminB6.value + other.vitaminB6.value),
        vitaminC: Nutrient.VitaminC(vitaminC.value + other.vitaminC.value),
        vitaminD: Nutrient.VitaminD(vitaminD.value + other.vitaminD.value),
        vitaminK: Nutrient.VitaminK(vitaminK.value + other.vitaminK.value),
        zinc: Nutrient.Zinc(zinc.value + other.zinc.value),
      );

  Nutrients operator -(Nutrients other) => Nutrients(
        calcium: Nutrient.Calcium(calcium.value - other.calcium.value),
        carbohydrate: Nutrient.Carbohydrate(
            carbohydrate.value - other.carbohydrate.value),
        cholesterol:
            Nutrient.Cholesterol(cholesterol.value - other.cholesterol.value),
        calories: Nutrient.Calories(calories.value - other.calories.value),
        saturatedFat: Nutrient.SaturatedFat(
            saturatedFat.value - other.saturatedFat.value),
        totalFat: Nutrient.TotalFat(totalFat.value - other.totalFat.value),
        transFat: Nutrient.TransFat(transFat.value - other.transFat.value),
        iron: Nutrient.Iron(iron.value - other.iron.value),
        fiber: Nutrient.Fiber(fiber.value - other.fiber.value),
        potassium: Nutrient.Potassium(potassium.value - other.potassium.value),
        sodium: Nutrient.Sodium(sodium.value - other.sodium.value),
        protein: Nutrient.Protein(protein.value - other.protein.value),
        sugars: Nutrient.Sugars(sugars.value - other.sugars.value),
        choline: Nutrient.Choline(choline.value - other.choline.value),
        copper: Nutrient.Copper(copper.value - other.copper.value),
        ala: Nutrient.ALA(ala.value - other.ala.value),
        linoleicAcid: Nutrient.LinoleicAcid(
            linoleicAcid.value - other.linoleicAcid.value),
        epa: Nutrient.EPA(epa.value - other.epa.value),
        dpa: Nutrient.DPA(dpa.value - other.dpa.value),
        dha: Nutrient.DHA(dha.value - other.dha.value),
        folate: Nutrient.Folate(folate.value - other.folate.value),
        magnesium: Nutrient.Magnesium(magnesium.value - other.magnesium.value),
        manganese: Nutrient.Manganese(manganese.value - other.manganese.value),
        niacin: Nutrient.Niacin(niacin.value - other.niacin.value),
        phosphorus:
            Nutrient.Phosphorus(phosphorus.value - other.phosphorus.value),
        pantothenicAcid: Nutrient.PantothenicAcid(
            pantothenicAcid.value - other.pantothenicAcid.value),
        riboflavin:
            Nutrient.Riboflavin(riboflavin.value - other.riboflavin.value),
        selenium: Nutrient.Selenium(selenium.value - other.selenium.value),
        thiamin: Nutrient.Thiamin(thiamin.value - other.thiamin.value),
        vitaminE: Nutrient.VitaminE(vitaminE.value - other.vitaminE.value),
        vitaminA: Nutrient.VitaminA(vitaminA.value - other.vitaminA.value),
        vitaminB12:
            Nutrient.VitaminB12(vitaminB12.value - other.vitaminB12.value),
        vitaminB6: Nutrient.VitaminB6(vitaminB6.value - other.vitaminB6.value),
        vitaminC: Nutrient.VitaminC(vitaminC.value - other.vitaminC.value),
        vitaminD: Nutrient.VitaminD(vitaminD.value - other.vitaminD.value),
        vitaminK: Nutrient.VitaminK(vitaminK.value - other.vitaminK.value),
        zinc: Nutrient.Zinc(zinc.value - other.zinc.value),
      );

  Nutrients operator *(num other) => Nutrients(
        calcium: Nutrient.Calcium(calcium.value * other),
        carbohydrate: Nutrient.Carbohydrate(carbohydrate.value * other),
        cholesterol: Nutrient.Cholesterol(cholesterol.value * other),
        calories: Nutrient.Calories(calories.value * other),
        saturatedFat: Nutrient.SaturatedFat(saturatedFat.value * other),
        totalFat: Nutrient.TotalFat(totalFat.value * other),
        transFat: Nutrient.TransFat(transFat.value * other),
        iron: Nutrient.Iron(iron.value * other),
        fiber: Nutrient.Fiber(fiber.value * other),
        potassium: Nutrient.Potassium(potassium.value * other),
        sodium: Nutrient.Sodium(sodium.value * other),
        protein: Nutrient.Protein(protein.value * other),
        sugars: Nutrient.Sugars(sugars.value * other),
        choline: Nutrient.Choline(choline.value * other),
        copper: Nutrient.Copper(copper.value * other),
        ala: Nutrient.ALA(ala.value * other),
        linoleicAcid: Nutrient.LinoleicAcid(linoleicAcid.value * other),
        epa: Nutrient.EPA(epa.value * other),
        dpa: Nutrient.DPA(dpa.value * other),
        dha: Nutrient.DHA(dha.value * other),
        folate: Nutrient.Folate(folate.value * other),
        magnesium: Nutrient.Magnesium(magnesium.value * other),
        manganese: Nutrient.Manganese(manganese.value * other),
        niacin: Nutrient.Niacin(niacin.value * other),
        phosphorus: Nutrient.Phosphorus(phosphorus.value * other),
        pantothenicAcid:
            Nutrient.PantothenicAcid(pantothenicAcid.value * other),
        riboflavin: Nutrient.Riboflavin(riboflavin.value * other),
        selenium: Nutrient.Selenium(selenium.value * other),
        thiamin: Nutrient.Thiamin(thiamin.value * other),
        vitaminE: Nutrient.VitaminE(vitaminE.value * other),
        vitaminA: Nutrient.VitaminA(vitaminA.value * other),
        vitaminB12: Nutrient.VitaminB12(vitaminB12.value * other),
        vitaminB6: Nutrient.VitaminB6(vitaminB6.value * other),
        vitaminC: Nutrient.VitaminC(vitaminC.value * other),
        vitaminD: Nutrient.VitaminD(vitaminD.value * other),
        vitaminK: Nutrient.VitaminK(vitaminK.value * other),
        zinc: Nutrient.Zinc(zinc.value * other),
      );

  Nutrients operator /(num other) => Nutrients(
        calcium: Nutrient.Calcium(calcium.value / other),
        carbohydrate: Nutrient.Carbohydrate(carbohydrate.value / other),
        cholesterol: Nutrient.Cholesterol(cholesterol.value / other),
        calories: Nutrient.Calories(calories.value / other),
        saturatedFat: Nutrient.SaturatedFat(saturatedFat.value / other),
        totalFat: Nutrient.TotalFat(totalFat.value / other),
        transFat: Nutrient.TransFat(transFat.value / other),
        iron: Nutrient.Iron(iron.value / other),
        fiber: Nutrient.Fiber(fiber.value / other),
        potassium: Nutrient.Potassium(potassium.value / other),
        sodium: Nutrient.Sodium(sodium.value / other),
        protein: Nutrient.Protein(protein.value / other),
        sugars: Nutrient.Sugars(sugars.value / other),
        choline: Nutrient.Choline(choline.value / other),
        copper: Nutrient.Copper(copper.value / other),
        ala: Nutrient.ALA(ala.value / other),
        linoleicAcid: Nutrient.LinoleicAcid(linoleicAcid.value / other),
        epa: Nutrient.EPA(epa.value / other),
        dpa: Nutrient.DPA(dpa.value / other),
        dha: Nutrient.DHA(dha.value / other),
        folate: Nutrient.Folate(folate.value / other),
        magnesium: Nutrient.Magnesium(magnesium.value / other),
        manganese: Nutrient.Manganese(manganese.value / other),
        niacin: Nutrient.Niacin(niacin.value / other),
        phosphorus: Nutrient.Phosphorus(phosphorus.value / other),
        pantothenicAcid:
            Nutrient.PantothenicAcid(pantothenicAcid.value / other),
        riboflavin: Nutrient.Riboflavin(riboflavin.value / other),
        selenium: Nutrient.Selenium(selenium.value / other),
        thiamin: Nutrient.Thiamin(thiamin.value / other),
        vitaminE: Nutrient.VitaminE(vitaminE.value / other),
        vitaminA: Nutrient.VitaminA(vitaminA.value / other),
        vitaminB12: Nutrient.VitaminB12(vitaminB12.value / other),
        vitaminB6: Nutrient.VitaminB6(vitaminB6.value / other),
        vitaminC: Nutrient.VitaminC(vitaminC.value / other),
        vitaminD: Nutrient.VitaminD(vitaminD.value / other),
        vitaminK: Nutrient.VitaminK(vitaminK.value / other),
        zinc: Nutrient.Zinc(zinc.value / other),
      );

  static Nutrients sum(Iterable<Nutrients> listOfNutrients) {
    if (listOfNutrients.isEmpty) {
      return Nutrients.zero();
    }
    return listOfNutrients.reduce((previous, current) => previous + current);
  }

  factory Nutrients.fromResponseBody(Map responseBody) {
    List temp = responseBody['full_nutrients'];
    Map<int, num> nut = {};
    for (Map map in temp) {
      nut[map['attr_id']] = map['value'];
    }
    return Nutrients(
      calcium: apiId2nutrient[301]!(nut[301] ?? 0),
      carbohydrate: apiId2nutrient[205]!(nut[205] ?? 0),
      cholesterol: apiId2nutrient[601]!(nut[601] ?? 0),
      calories: apiId2nutrient[208]!(nut[208] ?? 0),
      saturatedFat: apiId2nutrient[606]!(nut[606] ?? 0),
      totalFat: apiId2nutrient[204]!(nut[204] ?? 0),
      transFat: apiId2nutrient[605]!(nut[605] ?? 0),
      iron: apiId2nutrient[303]!(nut[303] ?? 0),
      fiber: apiId2nutrient[291]!(nut[291] ?? 0),
      potassium: apiId2nutrient[306]!(nut[306] ?? 0),
      sodium: apiId2nutrient[307]!(nut[307] ?? 0),
      protein: apiId2nutrient[203]!(nut[203] ?? 0),
      sugars: apiId2nutrient[539]!(nut[539] ?? 0),
      choline: apiId2nutrient[421]!(nut[421] ?? 0),
      copper: apiId2nutrient[312]!(nut[312] ?? 0),
      ala: apiId2nutrient[851]!(nut[851] ?? 0),
      linoleicAcid: apiId2nutrient[685]!(nut[685] ?? 0),
      epa: apiId2nutrient[629]!(nut[629] ?? 0),
      dpa: apiId2nutrient[631]!(nut[631] ?? 0),
      dha: apiId2nutrient[621]!(nut[621] ?? 0),
      folate: apiId2nutrient[417]!(nut[417] ?? 0),
      magnesium: apiId2nutrient[304]!(nut[304] ?? 0),
      manganese: apiId2nutrient[315]!(nut[315] ?? 0),
      niacin: apiId2nutrient[406]!(nut[406] ?? 0),
      phosphorus: apiId2nutrient[305]!(nut[305] ?? 0),
      pantothenicAcid: apiId2nutrient[410]!(nut[410] ?? 0),
      riboflavin: apiId2nutrient[405]!(nut[405] ?? 0),
      selenium: apiId2nutrient[317]!(nut[317] ?? 0),
      thiamin: apiId2nutrient[404]!(nut[404] ?? 0),
      vitaminE: apiId2nutrient[323]!(nut[323] ?? 0),
      vitaminA: apiId2nutrient[320]!(nut[320] ?? 0),
      vitaminB12: apiId2nutrient[418]!(nut[418] ?? 0),
      vitaminB6: apiId2nutrient[415]!(nut[415] ?? 0),
      vitaminC: apiId2nutrient[401]!(nut[401] ?? 0),
      vitaminD: apiId2nutrient[328]!(nut[328] ?? 0),
      vitaminK: apiId2nutrient[430]!(nut[430] ?? 0),
      zinc: apiId2nutrient[309]!(nut[309] ?? 0),
    );
  }

  // void round(){
  //   calcium = roundDecimal(calcium, 2);
  //   carbohydrate = roundDecimal(carbohydrate, 2);
  //   cholesterol = roundDecimal(cholesterol, 2);
  //   calories = roundDecimal(calories, 2);
  //   saturatedFat = roundDecimal(saturatedFat, 2);
  //   totalFat = roundDecimal(totalFat, 2);
  //   transFat = roundDecimal(transFat, 2);
  //   iron = roundDecimal(iron, 2);
  //   fiber = roundDecimal(fiber, 2);
  //   potassium = roundDecimal(potassium, 2);
  //   sodium = roundDecimal(sodium, 2);
  //   protein = roundDecimal(protein, 2);
  //   sugars = roundDecimal(sugars, 2);
  //   choline = roundDecimal(choline, 2);
  //   copper = roundDecimal(copper, 2);
  //   ala = roundDecimal(ala, 2);
  //   linoleicAcid = roundDecimal(linoleicAcid, 2);
  //   epa = roundDecimal(epa, 2);
  //   dpa = roundDecimal(dpa, 2);
  //   dha = roundDecimal(dha, 2);
  //   folate = roundDecimal(folate, 2);
  //   magnesium = roundDecimal(magnesium, 2);
  //   manganese = roundDecimal(manganese, 2);
  //   niacin = roundDecimal(niacin, 2);
  //   phosphorus = roundDecimal(phosphorus, 2);
  //   pantothenicAcid = roundDecimal(pantothenicAcid, 2);
  //   riboflavin = roundDecimal(riboflavin, 2);
  //   selenium = roundDecimal(selenium, 2);
  //   thiamin = roundDecimal(thiamin, 2);
  //   vitaminE = roundDecimal(vitaminE, 2);
  //   vitaminA = roundDecimal(vitaminA, 2);
  //   vitaminB12 = roundDecimal(vitaminB12, 2);
  //   vitaminB6 = roundDecimal(vitaminB6, 2);
  //   vitaminC = roundDecimal(vitaminC, 2);
  //   vitaminD = roundDecimal(vitaminD, 2);
  //   vitaminK = roundDecimal(vitaminK, 2);
  //   zinc = roundDecimal(zinc, 2);
  //   unsaturatedFat = roundDecimal(unsaturatedFat, 2);
  // }

  // <editor-fold desc="Dataclass Section">

  // <editor-fold desc="From Values Constructor">
  factory Nutrients.fromValues({
    num calcium = 0,
    num carbohydrate = 0,
    num cholesterol = 0,
    num calories = 0,
    num saturatedFat = 0,
    num totalFat = 0,
    num transFat = 0,
    num iron = 0,
    num fiber = 0,
    num potassium = 0,
    num sodium = 0,
    num protein = 0,
    num sugars = 0,
    num choline = 0,
    num copper = 0,
    num ala = 0,
    num linoleicAcid = 0,
    num epa = 0,
    num dpa = 0,
    num dha = 0,
    num folate = 0,
    num magnesium = 0,
    num manganese = 0,
    num niacin = 0,
    num phosphorus = 0,
    num pantothenicAcid = 0,
    num riboflavin = 0,
    num selenium = 0,
    num thiamin = 0,
    num vitaminE = 0,
    num vitaminA = 0,
    num vitaminB12 = 0,
    num vitaminB6 = 0,
    num vitaminC = 0,
    num vitaminD = 0,
    num vitaminK = 0,
    num zinc = 0,
  }) =>
      Nutrients(
          calcium: Nutrient.Calcium(calcium),
          carbohydrate: Nutrient.Carbohydrate(carbohydrate),
          cholesterol: Nutrient.Cholesterol(cholesterol),
          calories: Nutrient.Calories(calories),
          saturatedFat: Nutrient.SaturatedFat(saturatedFat),
          totalFat: Nutrient.TotalFat(totalFat),
          transFat: Nutrient.TransFat(transFat),
          iron: Nutrient.Iron(iron),
          fiber: Nutrient.Fiber(fiber),
          potassium: Nutrient.Potassium(potassium),
          sodium: Nutrient.Sodium(sodium),
          protein: Nutrient.Protein(protein),
          sugars: Nutrient.Sugars(sugars),
          choline: Nutrient.Choline(choline),
          copper: Nutrient.Copper(copper),
          ala: Nutrient.ALA(ala),
          linoleicAcid: Nutrient.LinoleicAcid(linoleicAcid),
          epa: Nutrient.EPA(epa),
          dpa: Nutrient.DPA(dpa),
          dha: Nutrient.DHA(dha),
          folate: Nutrient.Folate(folate),
          magnesium: Nutrient.Magnesium(magnesium),
          manganese: Nutrient.Manganese(manganese),
          niacin: Nutrient.Niacin(niacin),
          phosphorus: Nutrient.Phosphorus(phosphorus),
          pantothenicAcid: Nutrient.PantothenicAcid(pantothenicAcid),
          riboflavin: Nutrient.Riboflavin(riboflavin),
          selenium: Nutrient.Selenium(selenium),
          thiamin: Nutrient.Thiamin(thiamin),
          vitaminE: Nutrient.VitaminE(vitaminE),
          vitaminA: Nutrient.VitaminA(vitaminA),
          vitaminB12: Nutrient.VitaminB12(vitaminB12),
          vitaminB6: Nutrient.VitaminB6(vitaminB6),
          vitaminC: Nutrient.VitaminC(vitaminC),
          vitaminD: Nutrient.VitaminD(vitaminD),
          vitaminK: Nutrient.VitaminK(vitaminK),
          zinc: Nutrient.Zinc(zinc));

  // </editor-fold>

  // <Dataclass>

  Nutrients({
    required this.calcium,
    required this.carbohydrate,
    required this.cholesterol,
    required this.calories,
    required this.saturatedFat,
    required this.totalFat,
    required this.transFat,
    required this.iron,
    required this.fiber,
    required this.potassium,
    required this.sodium,
    required this.protein,
    required this.sugars,
    required this.choline,
    required this.copper,
    required this.ala,
    required this.linoleicAcid,
    required this.epa,
    required this.dpa,
    required this.dha,
    required this.folate,
    required this.magnesium,
    required this.manganese,
    required this.niacin,
    required this.phosphorus,
    required this.pantothenicAcid,
    required this.riboflavin,
    required this.selenium,
    required this.thiamin,
    required this.vitaminE,
    required this.vitaminA,
    required this.vitaminB12,
    required this.vitaminB6,
    required this.vitaminC,
    required this.vitaminD,
    required this.vitaminK,
    required this.zinc,
  }) {
    unsaturatedFat =
        Nutrient.UnsaturatedFat(totalFat.value - saturatedFat.value);
  }

  factory Nutrients.staticConstructor({
    required calcium,
    required carbohydrate,
    required cholesterol,
    required calories,
    required saturatedFat,
    required totalFat,
    required transFat,
    required iron,
    required fiber,
    required potassium,
    required sodium,
    required protein,
    required sugars,
    required choline,
    required copper,
    required ala,
    required linoleicAcid,
    required epa,
    required dpa,
    required dha,
    required folate,
    required magnesium,
    required manganese,
    required niacin,
    required phosphorus,
    required pantothenicAcid,
    required riboflavin,
    required selenium,
    required thiamin,
    required vitaminE,
    required vitaminA,
    required vitaminB12,
    required vitaminB6,
    required vitaminC,
    required vitaminD,
    required vitaminK,
    required zinc,
  }) =>
      Nutrients(
          calcium: calcium,
          carbohydrate: carbohydrate,
          cholesterol: cholesterol,
          calories: calories,
          saturatedFat: saturatedFat,
          totalFat: totalFat,
          transFat: transFat,
          iron: iron,
          fiber: fiber,
          potassium: potassium,
          sodium: sodium,
          protein: protein,
          sugars: sugars,
          choline: choline,
          copper: copper,
          ala: ala,
          linoleicAcid: linoleicAcid,
          epa: epa,
          dpa: dpa,
          dha: dha,
          folate: folate,
          magnesium: magnesium,
          manganese: manganese,
          niacin: niacin,
          phosphorus: phosphorus,
          pantothenicAcid: pantothenicAcid,
          riboflavin: riboflavin,
          selenium: selenium,
          thiamin: thiamin,
          vitaminE: vitaminE,
          vitaminA: vitaminA,
          vitaminB12: vitaminB12,
          vitaminB6: vitaminB6,
          vitaminC: vitaminC,
          vitaminD: vitaminD,
          vitaminK: vitaminK,
          zinc: zinc);

  Map<String, dynamic> get attributes__ => {
        "calcium": calcium,
        "carbohydrate": carbohydrate,
        "cholesterol": cholesterol,
        "calories": calories,
        "saturatedFat": saturatedFat,
        "totalFat": totalFat,
        "transFat": transFat,
        "iron": iron,
        "fiber": fiber,
        "potassium": potassium,
        "sodium": sodium,
        "protein": protein,
        "sugars": sugars,
        "choline": choline,
        "copper": copper,
        "ala": ala,
        "linoleicAcid": linoleicAcid,
        "epa": epa,
        "dpa": dpa,
        "dha": dha,
        "folate": folate,
        "magnesium": magnesium,
        "manganese": manganese,
        "niacin": niacin,
        "phosphorus": phosphorus,
        "pantothenicAcid": pantothenicAcid,
        "riboflavin": riboflavin,
        "selenium": selenium,
        "thiamin": thiamin,
        "vitaminE": vitaminE,
        "vitaminA": vitaminA,
        "vitaminB12": vitaminB12,
        "vitaminB6": vitaminB6,
        "vitaminC": vitaminC,
        "vitaminD": vitaminD,
        "vitaminK": vitaminK,
        "zinc": zinc,
        "unsaturatedFat": unsaturatedFat
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Nutrients &&
          runtimeType == other.runtimeType &&
          equals(calcium, other.calcium) &&
          equals(carbohydrate, other.carbohydrate) &&
          equals(cholesterol, other.cholesterol) &&
          equals(calories, other.calories) &&
          equals(saturatedFat, other.saturatedFat) &&
          equals(totalFat, other.totalFat) &&
          equals(transFat, other.transFat) &&
          equals(iron, other.iron) &&
          equals(fiber, other.fiber) &&
          equals(potassium, other.potassium) &&
          equals(sodium, other.sodium) &&
          equals(protein, other.protein) &&
          equals(sugars, other.sugars) &&
          equals(choline, other.choline) &&
          equals(copper, other.copper) &&
          equals(ala, other.ala) &&
          equals(linoleicAcid, other.linoleicAcid) &&
          equals(epa, other.epa) &&
          equals(dpa, other.dpa) &&
          equals(dha, other.dha) &&
          equals(folate, other.folate) &&
          equals(magnesium, other.magnesium) &&
          equals(manganese, other.manganese) &&
          equals(niacin, other.niacin) &&
          equals(phosphorus, other.phosphorus) &&
          equals(pantothenicAcid, other.pantothenicAcid) &&
          equals(riboflavin, other.riboflavin) &&
          equals(selenium, other.selenium) &&
          equals(thiamin, other.thiamin) &&
          equals(vitaminE, other.vitaminE) &&
          equals(vitaminA, other.vitaminA) &&
          equals(vitaminB12, other.vitaminB12) &&
          equals(vitaminB6, other.vitaminB6) &&
          equals(vitaminC, other.vitaminC) &&
          equals(vitaminD, other.vitaminD) &&
          equals(vitaminK, other.vitaminK) &&
          equals(zinc, other.zinc) &&
          equals(unsaturatedFat, other.unsaturatedFat));

  @override
  int get hashCode =>
      calcium.hashCode ^
      carbohydrate.hashCode ^
      cholesterol.hashCode ^
      calories.hashCode ^
      saturatedFat.hashCode ^
      totalFat.hashCode ^
      transFat.hashCode ^
      iron.hashCode ^
      fiber.hashCode ^
      potassium.hashCode ^
      sodium.hashCode ^
      protein.hashCode ^
      sugars.hashCode ^
      choline.hashCode ^
      copper.hashCode ^
      ala.hashCode ^
      linoleicAcid.hashCode ^
      epa.hashCode ^
      dpa.hashCode ^
      dha.hashCode ^
      folate.hashCode ^
      magnesium.hashCode ^
      manganese.hashCode ^
      niacin.hashCode ^
      phosphorus.hashCode ^
      pantothenicAcid.hashCode ^
      riboflavin.hashCode ^
      selenium.hashCode ^
      thiamin.hashCode ^
      vitaminE.hashCode ^
      vitaminA.hashCode ^
      vitaminB12.hashCode ^
      vitaminB6.hashCode ^
      vitaminC.hashCode ^
      vitaminD.hashCode ^
      vitaminK.hashCode ^
      zinc.hashCode ^
      unsaturatedFat.hashCode;

  @override
  String toString() =>
      'Nutrients(calcium: $calcium, carbohydrate: $carbohydrate, cholesterol: $cholesterol, calories: $calories, saturatedFat: $saturatedFat, totalFat: $totalFat, transFat: $transFat, iron: $iron, fiber: $fiber, potassium: $potassium, sodium: $sodium, protein: $protein, sugars: $sugars, choline: $choline, copper: $copper, ala: $ala, linoleicAcid: $linoleicAcid, epa: $epa, dpa: $dpa, dha: $dha, folate: $folate, magnesium: $magnesium, manganese: $manganese, niacin: $niacin, phosphorus: $phosphorus, pantothenicAcid: $pantothenicAcid, riboflavin: $riboflavin, selenium: $selenium, thiamin: $thiamin, vitaminE: $vitaminE, vitaminA: $vitaminA, vitaminB12: $vitaminB12, vitaminB6: $vitaminB6, vitaminC: $vitaminC, vitaminD: $vitaminD, vitaminK: $vitaminK, zinc: $zinc, unsaturatedFat: $unsaturatedFat)';
  String toStr() =>
      'Nutrients(calcium: ${calcium.value}${calcium.unit}, carbohydrate: ${carbohydrate.value}${carbohydrate.unit}, cholesterol: ${cholesterol.value}${cholesterol.unit}, calories: ${calories.value}${calories.unit}, saturatedFat: ${saturatedFat.value}${saturatedFat.unit}, totalFat: ${totalFat.value}${totalFat.unit}, transFat: ${transFat.value}${transFat.unit}, iron: ${iron.value}${iron.unit}, fiber: ${fiber.value}${fiber.unit}, potassium: ${potassium.value}${potassium.unit}, sodium: ${sodium.value}${sodium.unit}, protein: ${protein.value}${protein.unit}, sugars: ${sugars.value}${sugars.unit}, choline: ${choline.value}${choline.unit}, copper: ${copper.value}${copper.unit}, ala: ${ala.value}${ala.unit}, linoleicAcid: ${linoleicAcid.value}${linoleicAcid.unit}, epa: ${epa.value}${epa.unit}, dpa: ${dpa.value}${dpa.unit}, dha: ${dha.value}${dha.unit}, folate: ${folate.value}${folate.unit}, magnesium: ${magnesium.value}${magnesium.unit}, manganese: ${manganese.value}${manganese.unit}, niacin: ${niacin.value}${niacin.unit}, phosphorus: ${phosphorus.value}${phosphorus.unit}, pantothenicAcid: ${pantothenicAcid.value}${pantothenicAcid.unit}, riboflavin: ${riboflavin.value}${riboflavin.unit}, selenium: ${selenium.value}${selenium.unit}, thiamin: ${thiamin.value}${thiamin.unit}, vitaminE: ${vitaminE.value}${vitaminE.unit}, vitaminA: ${vitaminA.value}${vitaminA.unit}, vitaminB12: ${vitaminB12.value}${vitaminB12.unit}, vitaminB6: ${vitaminB6.value}${vitaminB6.unit}, vitaminC: ${vitaminC.value}${vitaminC.unit}, vitaminD: ${vitaminD.value}${vitaminD.unit}, vitaminK: ${vitaminK.value}${vitaminK.unit}, zinc: ${zinc.value}${zinc.unit}, unsaturatedFat: ${unsaturatedFat.value}${unsaturatedFat.unit})';
  Nutrients copyWith(
          {Nutrient? calcium,
          Nutrient? carbohydrate,
          Nutrient? cholesterol,
          Nutrient? calories,
          Nutrient? saturatedFat,
          Nutrient? totalFat,
          Nutrient? transFat,
          Nutrient? iron,
          Nutrient? fiber,
          Nutrient? potassium,
          Nutrient? sodium,
          Nutrient? protein,
          Nutrient? sugars,
          Nutrient? choline,
          Nutrient? copper,
          Nutrient? ala,
          Nutrient? linoleicAcid,
          Nutrient? epa,
          Nutrient? dpa,
          Nutrient? dha,
          Nutrient? folate,
          Nutrient? magnesium,
          Nutrient? manganese,
          Nutrient? niacin,
          Nutrient? phosphorus,
          Nutrient? pantothenicAcid,
          Nutrient? riboflavin,
          Nutrient? selenium,
          Nutrient? thiamin,
          Nutrient? vitaminE,
          Nutrient? vitaminA,
          Nutrient? vitaminB12,
          Nutrient? vitaminB6,
          Nutrient? vitaminC,
          Nutrient? vitaminD,
          Nutrient? vitaminK,
          Nutrient? zinc}) =>
      Nutrients(
          calcium: calcium ?? this.calcium,
          carbohydrate: carbohydrate ?? this.carbohydrate,
          cholesterol: cholesterol ?? this.cholesterol,
          calories: calories ?? this.calories,
          saturatedFat: saturatedFat ?? this.saturatedFat,
          totalFat: totalFat ?? this.totalFat,
          transFat: transFat ?? this.transFat,
          iron: iron ?? this.iron,
          fiber: fiber ?? this.fiber,
          potassium: potassium ?? this.potassium,
          sodium: sodium ?? this.sodium,
          protein: protein ?? this.protein,
          sugars: sugars ?? this.sugars,
          choline: choline ?? this.choline,
          copper: copper ?? this.copper,
          ala: ala ?? this.ala,
          linoleicAcid: linoleicAcid ?? this.linoleicAcid,
          epa: epa ?? this.epa,
          dpa: dpa ?? this.dpa,
          dha: dha ?? this.dha,
          folate: folate ?? this.folate,
          magnesium: magnesium ?? this.magnesium,
          manganese: manganese ?? this.manganese,
          niacin: niacin ?? this.niacin,
          phosphorus: phosphorus ?? this.phosphorus,
          pantothenicAcid: pantothenicAcid ?? this.pantothenicAcid,
          riboflavin: riboflavin ?? this.riboflavin,
          selenium: selenium ?? this.selenium,
          thiamin: thiamin ?? this.thiamin,
          vitaminE: vitaminE ?? this.vitaminE,
          vitaminA: vitaminA ?? this.vitaminA,
          vitaminB12: vitaminB12 ?? this.vitaminB12,
          vitaminB6: vitaminB6 ?? this.vitaminB6,
          vitaminC: vitaminC ?? this.vitaminC,
          vitaminD: vitaminD ?? this.vitaminD,
          vitaminK: vitaminK ?? this.vitaminK,
          zinc: zinc ?? this.zinc);

  factory Nutrients.zero() => Nutrients(
      calcium: Nutrient.Calcium(0),
      carbohydrate: Nutrient.Carbohydrate(0),
      cholesterol: Nutrient.Cholesterol(0),
      calories: Nutrient.Calories(0),
      saturatedFat: Nutrient.SaturatedFat(0),
      totalFat: Nutrient.TotalFat(0),
      transFat: Nutrient.TransFat(0),
      iron: Nutrient.Iron(0),
      fiber: Nutrient.Fiber(0),
      potassium: Nutrient.Potassium(0),
      sodium: Nutrient.Sodium(0),
      protein: Nutrient.Protein(0),
      sugars: Nutrient.Sugars(0),
      choline: Nutrient.Choline(0),
      copper: Nutrient.Copper(0),
      ala: Nutrient.ALA(0),
      linoleicAcid: Nutrient.LinoleicAcid(0),
      epa: Nutrient.EPA(0),
      dpa: Nutrient.DPA(0),
      dha: Nutrient.DHA(0),
      folate: Nutrient.Folate(0),
      magnesium: Nutrient.Magnesium(0),
      manganese: Nutrient.Manganese(0),
      niacin: Nutrient.Niacin(0),
      phosphorus: Nutrient.Phosphorus(0),
      pantothenicAcid: Nutrient.PantothenicAcid(0),
      riboflavin: Nutrient.Riboflavin(0),
      selenium: Nutrient.Selenium(0),
      thiamin: Nutrient.Thiamin(0),
      vitaminE: Nutrient.VitaminE(0),
      vitaminA: Nutrient.VitaminA(0),
      vitaminB12: Nutrient.VitaminB12(0),
      vitaminB6: Nutrient.VitaminB6(0),
      vitaminC: Nutrient.VitaminC(0),
      vitaminD: Nutrient.VitaminD(0),
      vitaminK: Nutrient.VitaminK(0),
      zinc: Nutrient.Zinc(0));

  String toJson() => jsonEncode(toMap());

  Map<String, dynamic> toMap() =>
      {'__type': 'Nutrients', ...nestedJsonMap(attributes__)};

  factory Nutrients.fromJson(String json) =>
      Nutrients.fromMap(jsonDecode(json));

  factory Nutrients.fromMap(Map map) {
    Nutrient calcium = dejsonify(map['calcium']);
    Nutrient carbohydrate = dejsonify(map['carbohydrate']);
    Nutrient cholesterol = dejsonify(map['cholesterol']);
    Nutrient calories = dejsonify(map['calories']);
    Nutrient saturatedFat = dejsonify(map['saturatedFat']);
    Nutrient totalFat = dejsonify(map['totalFat']);
    Nutrient transFat = dejsonify(map['transFat']);
    Nutrient iron = dejsonify(map['iron']);
    Nutrient fiber = dejsonify(map['fiber']);
    Nutrient potassium = dejsonify(map['potassium']);
    Nutrient sodium = dejsonify(map['sodium']);
    Nutrient protein = dejsonify(map['protein']);
    Nutrient sugars = dejsonify(map['sugars']);
    Nutrient choline = dejsonify(map['choline']);
    Nutrient copper = dejsonify(map['copper']);
    Nutrient ala = dejsonify(map['ala']);
    Nutrient linoleicAcid = dejsonify(map['linoleicAcid']);
    Nutrient epa = dejsonify(map['epa']);
    Nutrient dpa = dejsonify(map['dpa']);
    Nutrient dha = dejsonify(map['dha']);
    Nutrient folate = dejsonify(map['folate']);
    Nutrient magnesium = dejsonify(map['magnesium']);
    Nutrient manganese = dejsonify(map['manganese']);
    Nutrient niacin = dejsonify(map['niacin']);
    Nutrient phosphorus = dejsonify(map['phosphorus']);
    Nutrient pantothenicAcid = dejsonify(map['pantothenicAcid']);
    Nutrient riboflavin = dejsonify(map['riboflavin']);
    Nutrient selenium = dejsonify(map['selenium']);
    Nutrient thiamin = dejsonify(map['thiamin']);
    Nutrient vitaminE = dejsonify(map['vitaminE']);
    Nutrient vitaminA = dejsonify(map['vitaminA']);
    Nutrient vitaminB12 = dejsonify(map['vitaminB12']);
    Nutrient vitaminB6 = dejsonify(map['vitaminB6']);
    Nutrient vitaminC = dejsonify(map['vitaminC']);
    Nutrient vitaminD = dejsonify(map['vitaminD']);
    Nutrient vitaminK = dejsonify(map['vitaminK']);
    Nutrient zinc = dejsonify(map['zinc']);

    // No casting

    return Nutrients(
        calcium: calcium,
        carbohydrate: carbohydrate,
        cholesterol: cholesterol,
        calories: calories,
        saturatedFat: saturatedFat,
        totalFat: totalFat,
        transFat: transFat,
        iron: iron,
        fiber: fiber,
        potassium: potassium,
        sodium: sodium,
        protein: protein,
        sugars: sugars,
        choline: choline,
        copper: copper,
        ala: ala,
        linoleicAcid: linoleicAcid,
        epa: epa,
        dpa: dpa,
        dha: dha,
        folate: folate,
        magnesium: magnesium,
        manganese: manganese,
        niacin: niacin,
        phosphorus: phosphorus,
        pantothenicAcid: pantothenicAcid,
        riboflavin: riboflavin,
        selenium: selenium,
        thiamin: thiamin,
        vitaminE: vitaminE,
        vitaminA: vitaminA,
        vitaminB12: vitaminB12,
        vitaminB6: vitaminB6,
        vitaminC: vitaminC,
        vitaminD: vitaminD,
        vitaminK: vitaminK,
        zinc: zinc);
  }
// </Dataclass>

// </editor-fold>
}

@Dataclass()
class DRI {
  String name;
  num? dri;
  num? upperLimit;
  String unit;
  String? note;
  bool tracked = true;

  String compare(val) {
    if (val is Nutrient) {
      val = val.value;
    } else if (val is num) {
      val = val.toDouble();
    } else if (val is int) {
      val = val.toDouble();
    }
    evaluate() {
      if (upperLimit == null && dri == null) {
        return roundDecimal(val, 2).toString();
      } else if (upperLimit == null) {
        if (val >= dri) {
          return roundDecimal(val, 2).toString();
        } else {
          return '-${roundDecimal((dri! - val).toDouble(), 2)}';
        }
      } else if (dri == null) {
        if (val <= upperLimit) {
          return roundDecimal(val, 2).toString();
        } else {
          return '+${roundDecimal((val - upperLimit!).toDouble(), 2)}';
        }
      } else {
        if (dri! <= val && val <= upperLimit) {
          return roundDecimal(val, 2).toString();
        } else if (val > upperLimit) {
          return '+${roundDecimal((val - upperLimit!).toDouble(), 2)}';
        } else {
          return '-${roundDecimal((dri! - val).toDouble(), 2)}';
        }
      }
    }

    return '${evaluate()} $unit';
  }

  DRI operator *(num num) => copyWith(
      dri: dri == null ? null : dri! * num,
      upperLimit: upperLimit == null ? null : upperLimit! * num);

  DRI operator /(num num) => copyWith(
      dri: dri == null ? null : dri! / num,
      upperLimit: upperLimit == null ? null : upperLimit! / num);

  void convertUnit(num multiplier, String unit) {
    this.unit = unit;
    upperLimit = convertUnitNum(upperLimit, multiplier);
    dri = convertUnitNum(dri, multiplier);
  }

  // <editor-fold desc="Dataclass Objects">
  DRI(this.name,
      {this.dri,
      this.upperLimit,
      required this.unit,
      this.note,
      this.tracked = true}) {
    if (dri == 0) {
      dri = null;
    }
    if (upperLimit == 0) {
      upperLimit = null;
    }
    if (unit.toLowerCase() == 'grams') {
      unit = 'g';
    }
  }

  factory DRI.sugars(AnthroMetrics anthro) {
    int val = anthro.sex == Sex.M ? 36 : 25;
    return DRI('Sugars', unit: 'g', upperLimit: val);
  }

  @override
  String toString() {
    if (upperLimit != null) {
      return '$name: $dri - $upperLimit $unit';
    } else {
      return '$name: $dri $unit';
    }
  }

  void substitutions() {
    if (name == 'Estimated Daily Caloric Needs') {
      name = 'Calories';
    }
    if (name == 'Sodium') {
      upperLimit = 3000;
    }
    if (name == 'Magnesium') {
      upperLimit = null;
    }
    if (name == 'Choline') {
      convertUnit(1000, 'mg');
    }
    if (name == 'Phosphorus') {
      convertUnit(1000, 'mg');
    }
    if (name == 'Copper') {
      convertUnit(1 / 1000, 'mg');
    }
    if (name == 'Linoleic Acid') {
      tracked = false;
    }
  }

  factory DRI.driMacro(List<String> instantiationString,
      [AnthroMetrics? anthro]) {
    RegExpMatch? search = macroSearch.firstMatch(instantiationString[1]);
    String name = instantiationString[0];
    num? dri;
    num? ul;
    String? unit;

    if (search != null) {
      List<String?> values = RegExp(r'[0-9,.]+')
          .allMatches(search.group(0)!)
          .map((e) => e.group(0))
          .toList();
      dri = toNum(values[0]);
      ul = toNum(values[1]);
      unit = RegExp(r'[A-Za-z]+').firstMatch(search.group(0)!)?.group(0);
    } else {
      RegExpMatch? search = valueUnitSearch.firstMatch(instantiationString[1]);
      dri = search != null
          ? toNum(RegExp(r'[0-9,.]+').firstMatch(search.group(0)!)?.group(0))
          : null;
      unit = search != null
          ? RegExp(r'[A-Za-z]+').firstMatch(search.group(0)!)?.group(0)
          : null;
    }
    if (name == 'Protein' && anthro != null) {
      ul = (anthro.weight * 0.8).round();
    }
    DRI result = DRI(name, dri: dri, upperLimit: ul, unit: unit!);
    result.substitutions();
    return result;
  }

  factory DRI.driMicro(List<String> instantiationString) {
    RegExpMatch? driLine = valueUnitSearch.firstMatch(instantiationString[1]);
    RegExpMatch? ulLine = valueUnitSearch.firstMatch(instantiationString[2]);
    String? dri = driLine?.group(1);
    String? unit = driLine?.group(2);
    String? ul = ulLine?.group(1);
    DRI result = DRI(instantiationString[0],
        dri: toNum(dri), upperLimit: toNum(ul), unit: unit!);
    result.substitutions();
    return result;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DRI &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          dri == other.dri &&
          upperLimit == other.upperLimit &&
          unit == other.unit;

  @override
  int get hashCode =>
      name.hashCode ^ dri.hashCode ^ upperLimit.hashCode ^ unit.hashCode;

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'dri': dri,
      'upperLimit': upperLimit,
      'unit': unit,
      'note': note,
      'tracked': tracked,
      '__type': 'DRI'
    };
  }

  factory DRI.fromMap(Map<String, dynamic> map) {
    return DRI(map['name'] as String,
        dri: map['dri'] as num?,
        upperLimit: map['upperLimit'] as num?,
        unit: map['unit'] as String,
        tracked: map['tracked'] ?? true,
        note: map['note'] as String?);
  }

  DRI copyWith({dri, upperLimit}) => DRI(name,
      dri: dri ?? this.dri,
      upperLimit: upperLimit ?? this.upperLimit,
      note: note,
      unit: unit,
      tracked: tracked);
//</editor-fold>
}

num? convertUnitNum(num? number, num multiplier) {
  if (number == null) {
    return null;
  }
  number *= multiplier;
  if (number.isInt) {
    return number.toInt();
  }
  return number;
}

@Dataclass(constructor: false)
class DRIS {
  DRI calcium;
  DRI carbohydrate;
  DRI cholesterol;
  DRI calories;
  DRI totalFat;
  DRI iron;
  DRI fiber;
  DRI potassium;
  DRI sodium;
  DRI protein;
  DRI sugars;
  DRI choline;
  DRI copper;
  DRI ala;
  DRI linoleicAcid;
  DRI epa;
  DRI dpa;
  DRI dha;
  DRI folate;
  DRI magnesium;
  DRI manganese;
  DRI niacin;
  DRI phosphorus;
  DRI pantothenicAcid;
  DRI riboflavin;
  DRI selenium;
  DRI thiamin;
  DRI vitaminE;
  DRI vitaminA;
  DRI vitaminB12;
  DRI vitaminB6;
  DRI vitaminC;
  DRI vitaminD;
  DRI vitaminK;
  DRI zinc;
  late DRI transFat;
  late DRI unsaturatedFat;
  late DRI saturatedFat;

  // Create desired percentages as a setter?
  // CREATE MACRO SETTERS?
  factory DRIS.fromPreparedList(List<DRI> list) {
    Map<String, DRI> map = {for (DRI dri in list) dri.name: dri};
    return DRIS.fromMap(map);
  }

  DRIS operator *(num num) {
    return DRIS(
      calcium: calcium * num,
      carbohydrate: carbohydrate * num,
      cholesterol: cholesterol * num,
      calories: calories * num,
      totalFat: totalFat * num,
      // transFat: transFat * num,
      iron: iron * num,
      fiber: fiber * num,
      potassium: potassium * num,
      sodium: sodium * num,
      protein: protein * num,
      sugars: sugars * num,
      choline: choline * num,
      copper: copper * num,
      ala: ala * num,
      linoleicAcid: linoleicAcid * num,
      epa: epa * num,
      dpa: dpa * num,
      dha: dha * num,
      folate: folate * num,
      magnesium: magnesium * num,
      manganese: manganese * num,
      niacin: niacin * num,
      phosphorus: phosphorus * num,
      pantothenicAcid: pantothenicAcid * num,
      riboflavin: riboflavin * num,
      selenium: selenium * num,
      thiamin: thiamin * num,
      vitaminE: vitaminE * num,
      vitaminA: vitaminA * num,
      vitaminB12: vitaminB12 * num,
      vitaminB6: vitaminB6 * num,
      vitaminC: vitaminC * num,
      vitaminD: vitaminD * num,
      vitaminK: vitaminK * num,
      zinc: zinc * num,
    );
  }

  DRIS operator /(num num) {
    return DRIS(
      calcium: calcium / num,
      carbohydrate: carbohydrate / num,
      cholesterol: cholesterol / num,
      calories: calories / num,
      totalFat: totalFat / num,
      // transFat: transFat / num,
      iron: iron / num,
      fiber: fiber / num,
      potassium: potassium / num,
      sodium: sodium / num,
      protein: protein / num,
      sugars: sugars / num,
      choline: choline / num,
      copper: copper / num,
      ala: ala / num,
      linoleicAcid: linoleicAcid / num,
      epa: epa / num,
      dpa: dpa / num,
      dha: dha / num,
      folate: folate / num,
      magnesium: magnesium / num,
      manganese: manganese / num,
      niacin: niacin / num,
      phosphorus: phosphorus / num,
      pantothenicAcid: pantothenicAcid / num,
      riboflavin: riboflavin / num,
      selenium: selenium / num,
      thiamin: thiamin / num,
      vitaminE: vitaminE / num,
      vitaminA: vitaminA / num,
      vitaminB12: vitaminB12 / num,
      vitaminB6: vitaminB6 / num,
      vitaminC: vitaminC / num,
      vitaminD: vitaminD / num,
      vitaminK: vitaminK / num,
      zinc: zinc / num,
    );
  }

  static Future<DRIS> fromAPI(AnthroMetrics metrics) async {
    try {
      String responseBody = await driCalc(metrics);
      List<DRI> listDRIS = parseDRI(responseBody, metrics);
      listDRIS.add(DRI.sugars(metrics));
      DRIS value = DRIS.fromMap(prepDRIMapFromAPI(listDRIS));
      value.calories.upperLimit = value.calories.dri;
      value.calories.dri = value.calories.dri! * .9;
      return value;
    } on Exception catch (_) {
      rethrow;
    }
  }

  /// Returns Map
  ///   key = DRIS attribute name of DRI (for ex: vitaminB6) with
  ///   value = [dri, nutrient, comparison as String]
  Map<String, List> comparator(Nutrients nutrients) {
    Map<String, List> result = {};
    for (String strNutrient in attributes__.keys) {
      DRI dri = attributes__[strNutrient];
      if (!dri.tracked) {
        continue;
      }
      Nutrient nutrient = nutrients.attributes__[strNutrient];
      String comparison = dri.compare(nutrient);
      result[strNutrient] = [
        dri,
        nutrient,
        comparison,
      ];
    }
    return result;
  }

  // <editor-fold desc="Dataclass Section">
  DRIS({
    required this.calcium,
    required this.carbohydrate,
    required this.cholesterol,
    required this.calories,
    required this.totalFat,
    required this.iron,
    required this.fiber,
    required this.potassium,
    required this.sodium,
    required this.protein,
    required this.sugars,
    required this.choline,
    required this.copper,
    required this.ala,
    required this.linoleicAcid,
    required this.epa,
    required this.dpa,
    required this.dha,
    required this.folate,
    required this.magnesium,
    required this.manganese,
    required this.niacin,
    required this.phosphorus,
    required this.pantothenicAcid,
    required this.riboflavin,
    required this.selenium,
    required this.thiamin,
    required this.vitaminE,
    required this.vitaminA,
    required this.vitaminB12,
    required this.vitaminB6,
    required this.vitaminC,
    required this.vitaminD,
    required this.vitaminK,
    required this.zinc,
  }) {
    transFat = DRI('Trans Fat', unit: 'g', upperLimit: 1);
    saturatedFat = // 90 bc 10% of cal should be sat * 9kcal per g fat
        DRI('Saturated Fat',
            unit: 'g', upperLimit: (calories.upperLimit ?? calories.dri!) / 90);
    unsaturatedFat = DRI('Unsaturated Fat',
        unit: 'g', dri: totalFat.dri! * .9, upperLimit: totalFat.upperLimit);
  }

  static Map<String, String> representor = {
    "calcium": emoji.get('bone').code,
    "carbohydrate": emoji.get('bread').code,
    "cholesterol": 'cholesterol',
    "calories": emoji.get('fire').code,
    "iron": 'Fe',
    "fiber": emoji.get('toilet').code,
    "potassium": emoji.get('banana').code,
    "sodium": emoji.get('salt').code,
    "protein": '\u{1f969}',
    "sugars": emoji.get('candy').code,
    "choline": 'choline',
    "copper": 'Cu',
    "ala": 'ala',
    "linoleicAcid": 'linoleic acid',
    "epa": 'epa',
    "dpa": 'dpa',
    "dha": 'dha',
    "folate": 'B9',
    "magnesium": 'Mg',
    "manganese": 'Mn',
    "niacin": 'B3',
    "phosphorus": 'P',
    "pantothenicAcid": 'B5',
    "riboflavin": 'B2',
    "selenium": 'Se',
    "thiamin": 'B1',
    "vitaminE": 'E',
    "vitaminA": 'A',
    "vitaminB12": 'B12',
    "vitaminB6": 'B6',
    "vitaminC": 'C',
    "vitaminD": 'D',
    "vitaminK": 'K',
    "zinc": 'Zn',
    "transFat": '\u{1F364}',
    "unsaturatedFat": olive,
    "saturatedFat": butter
  };

  @Generate()
  // <Dataclass>

  factory DRIS.staticConstructor({
    required calcium,
    required carbohydrate,
    required cholesterol,
    required calories,
    required totalFat,
    required iron,
    required fiber,
    required potassium,
    required sodium,
    required protein,
    required sugars,
    required choline,
    required copper,
    required ala,
    required linoleicAcid,
    required epa,
    required dpa,
    required dha,
    required folate,
    required magnesium,
    required manganese,
    required niacin,
    required phosphorus,
    required pantothenicAcid,
    required riboflavin,
    required selenium,
    required thiamin,
    required vitaminE,
    required vitaminA,
    required vitaminB12,
    required vitaminB6,
    required vitaminC,
    required vitaminD,
    required vitaminK,
    required zinc,
  }) =>
      DRIS(
          calcium: calcium,
          carbohydrate: carbohydrate,
          cholesterol: cholesterol,
          calories: calories,
          totalFat: totalFat,
          iron: iron,
          fiber: fiber,
          potassium: potassium,
          sodium: sodium,
          protein: protein,
          sugars: sugars,
          choline: choline,
          copper: copper,
          ala: ala,
          linoleicAcid: linoleicAcid,
          epa: epa,
          dpa: dpa,
          dha: dha,
          folate: folate,
          magnesium: magnesium,
          manganese: manganese,
          niacin: niacin,
          phosphorus: phosphorus,
          pantothenicAcid: pantothenicAcid,
          riboflavin: riboflavin,
          selenium: selenium,
          thiamin: thiamin,
          vitaminE: vitaminE,
          vitaminA: vitaminA,
          vitaminB12: vitaminB12,
          vitaminB6: vitaminB6,
          vitaminC: vitaminC,
          vitaminD: vitaminD,
          vitaminK: vitaminK,
          zinc: zinc);

  Map<String, dynamic> get attributes__ => {
        "calcium": calcium,
        "carbohydrate": carbohydrate,
        "cholesterol": cholesterol,
        "calories": calories,
        "totalFat": totalFat,
        "iron": iron,
        "fiber": fiber,
        "potassium": potassium,
        "sodium": sodium,
        "protein": protein,
        "sugars": sugars,
        "choline": choline,
        "copper": copper,
        "ala": ala,
        "linoleicAcid": linoleicAcid,
        "epa": epa,
        "dpa": dpa,
        "dha": dha,
        "folate": folate,
        "magnesium": magnesium,
        "manganese": manganese,
        "niacin": niacin,
        "phosphorus": phosphorus,
        "pantothenicAcid": pantothenicAcid,
        "riboflavin": riboflavin,
        "selenium": selenium,
        "thiamin": thiamin,
        "vitaminE": vitaminE,
        "vitaminA": vitaminA,
        "vitaminB12": vitaminB12,
        "vitaminB6": vitaminB6,
        "vitaminC": vitaminC,
        "vitaminD": vitaminD,
        "vitaminK": vitaminK,
        "zinc": zinc,
        "transFat": transFat,
        "unsaturatedFat": unsaturatedFat,
        "saturatedFat": saturatedFat
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DRIS &&
          runtimeType == other.runtimeType &&
          equals(calcium, other.calcium) &&
          equals(carbohydrate, other.carbohydrate) &&
          equals(cholesterol, other.cholesterol) &&
          equals(calories, other.calories) &&
          equals(totalFat, other.totalFat) &&
          equals(iron, other.iron) &&
          equals(fiber, other.fiber) &&
          equals(potassium, other.potassium) &&
          equals(sodium, other.sodium) &&
          equals(protein, other.protein) &&
          equals(sugars, other.sugars) &&
          equals(choline, other.choline) &&
          equals(copper, other.copper) &&
          equals(ala, other.ala) &&
          equals(linoleicAcid, other.linoleicAcid) &&
          equals(epa, other.epa) &&
          equals(dpa, other.dpa) &&
          equals(dha, other.dha) &&
          equals(folate, other.folate) &&
          equals(magnesium, other.magnesium) &&
          equals(manganese, other.manganese) &&
          equals(niacin, other.niacin) &&
          equals(phosphorus, other.phosphorus) &&
          equals(pantothenicAcid, other.pantothenicAcid) &&
          equals(riboflavin, other.riboflavin) &&
          equals(selenium, other.selenium) &&
          equals(thiamin, other.thiamin) &&
          equals(vitaminE, other.vitaminE) &&
          equals(vitaminA, other.vitaminA) &&
          equals(vitaminB12, other.vitaminB12) &&
          equals(vitaminB6, other.vitaminB6) &&
          equals(vitaminC, other.vitaminC) &&
          equals(vitaminD, other.vitaminD) &&
          equals(vitaminK, other.vitaminK) &&
          equals(zinc, other.zinc) &&
          equals(transFat, other.transFat) &&
          equals(unsaturatedFat, other.unsaturatedFat) &&
          equals(saturatedFat, other.saturatedFat));

  @override
  int get hashCode =>
      calcium.hashCode ^
      carbohydrate.hashCode ^
      cholesterol.hashCode ^
      calories.hashCode ^
      totalFat.hashCode ^
      iron.hashCode ^
      fiber.hashCode ^
      potassium.hashCode ^
      sodium.hashCode ^
      protein.hashCode ^
      sugars.hashCode ^
      choline.hashCode ^
      copper.hashCode ^
      ala.hashCode ^
      linoleicAcid.hashCode ^
      epa.hashCode ^
      dpa.hashCode ^
      dha.hashCode ^
      folate.hashCode ^
      magnesium.hashCode ^
      manganese.hashCode ^
      niacin.hashCode ^
      phosphorus.hashCode ^
      pantothenicAcid.hashCode ^
      riboflavin.hashCode ^
      selenium.hashCode ^
      thiamin.hashCode ^
      vitaminE.hashCode ^
      vitaminA.hashCode ^
      vitaminB12.hashCode ^
      vitaminB6.hashCode ^
      vitaminC.hashCode ^
      vitaminD.hashCode ^
      vitaminK.hashCode ^
      zinc.hashCode ^
      transFat.hashCode ^
      unsaturatedFat.hashCode ^
      saturatedFat.hashCode;

  @override
  String toString() =>
      'DRIS(calcium: $calcium, carbohydrate: $carbohydrate, cholesterol: $cholesterol, calories: $calories, totalFat: $totalFat, iron: $iron, fiber: $fiber, potassium: $potassium, sodium: $sodium, protein: $protein, sugars: $sugars, choline: $choline, copper: $copper, ala: $ala, linoleicAcid: $linoleicAcid, epa: $epa, dpa: $dpa, dha: $dha, folate: $folate, magnesium: $magnesium, manganese: $manganese, niacin: $niacin, phosphorus: $phosphorus, pantothenicAcid: $pantothenicAcid, riboflavin: $riboflavin, selenium: $selenium, thiamin: $thiamin, vitaminE: $vitaminE, vitaminA: $vitaminA, vitaminB12: $vitaminB12, vitaminB6: $vitaminB6, vitaminC: $vitaminC, vitaminD: $vitaminD, vitaminK: $vitaminK, zinc: $zinc, transFat: $transFat, unsaturatedFat: $unsaturatedFat, saturatedFat: $saturatedFat)';

  DRIS copyWithDRIS(
          {DRI? calcium,
          DRI? carbohydrate,
          DRI? cholesterol,
          DRI? calories,
          DRI? totalFat,
          DRI? iron,
          DRI? fiber,
          DRI? potassium,
          DRI? sodium,
          DRI? protein,
          DRI? sugars,
          DRI? choline,
          DRI? copper,
          DRI? ala,
          DRI? linoleicAcid,
          DRI? epa,
          DRI? dpa,
          DRI? dha,
          DRI? folate,
          DRI? magnesium,
          DRI? manganese,
          DRI? niacin,
          DRI? phosphorus,
          DRI? pantothenicAcid,
          DRI? riboflavin,
          DRI? selenium,
          DRI? thiamin,
          DRI? vitaminE,
          DRI? vitaminA,
          DRI? vitaminB12,
          DRI? vitaminB6,
          DRI? vitaminC,
          DRI? vitaminD,
          DRI? vitaminK,
          DRI? zinc}) =>
      DRIS(
          calcium: calcium ?? this.calcium,
          carbohydrate: carbohydrate ?? this.carbohydrate,
          cholesterol: cholesterol ?? this.cholesterol,
          calories: calories ?? this.calories,
          totalFat: totalFat ?? this.totalFat,
          iron: iron ?? this.iron,
          fiber: fiber ?? this.fiber,
          potassium: potassium ?? this.potassium,
          sodium: sodium ?? this.sodium,
          protein: protein ?? this.protein,
          sugars: sugars ?? this.sugars,
          choline: choline ?? this.choline,
          copper: copper ?? this.copper,
          ala: ala ?? this.ala,
          linoleicAcid: linoleicAcid ?? this.linoleicAcid,
          epa: epa ?? this.epa,
          dpa: dpa ?? this.dpa,
          dha: dha ?? this.dha,
          folate: folate ?? this.folate,
          magnesium: magnesium ?? this.magnesium,
          manganese: manganese ?? this.manganese,
          niacin: niacin ?? this.niacin,
          phosphorus: phosphorus ?? this.phosphorus,
          pantothenicAcid: pantothenicAcid ?? this.pantothenicAcid,
          riboflavin: riboflavin ?? this.riboflavin,
          selenium: selenium ?? this.selenium,
          thiamin: thiamin ?? this.thiamin,
          vitaminE: vitaminE ?? this.vitaminE,
          vitaminA: vitaminA ?? this.vitaminA,
          vitaminB12: vitaminB12 ?? this.vitaminB12,
          vitaminB6: vitaminB6 ?? this.vitaminB6,
          vitaminC: vitaminC ?? this.vitaminC,
          vitaminD: vitaminD ?? this.vitaminD,
          vitaminK: vitaminK ?? this.vitaminK,
          zinc: zinc ?? this.zinc);

  String toJson() => jsonEncode(toMap());
  Map<String, dynamic> toMap() =>
      {'__type': 'DRIS', ...nestedJsonMap(attributes__)};

  factory DRIS.fromJson(String json) => DRIS.fromMap(jsonDecode(json));

  factory DRIS.fromMap(Map map) {
    DRI calcium = dejsonify(map['calcium']);
    DRI carbohydrate = dejsonify(map['carbohydrate']);
    DRI cholesterol = dejsonify(map['cholesterol']);
    DRI calories = dejsonify(map['calories']);
    DRI totalFat = dejsonify(map['totalFat']);
    DRI iron = dejsonify(map['iron']);
    DRI fiber = dejsonify(map['fiber']);
    DRI potassium = dejsonify(map['potassium']);
    DRI sodium = dejsonify(map['sodium']);
    DRI protein = dejsonify(map['protein']);
    DRI sugars = dejsonify(map['sugars']);
    DRI choline = dejsonify(map['choline']);
    DRI copper = dejsonify(map['copper']);
    DRI ala = dejsonify(map['ala']);
    DRI linoleicAcid = dejsonify(map['linoleicAcid']);
    DRI epa = dejsonify(map['epa']);
    DRI dpa = dejsonify(map['dpa']);
    DRI dha = dejsonify(map['dha']);
    DRI folate = dejsonify(map['folate']);
    DRI magnesium = dejsonify(map['magnesium']);
    DRI manganese = dejsonify(map['manganese']);
    DRI niacin = dejsonify(map['niacin']);
    DRI phosphorus = dejsonify(map['phosphorus']);
    DRI pantothenicAcid = dejsonify(map['pantothenicAcid']);
    DRI riboflavin = dejsonify(map['riboflavin']);
    DRI selenium = dejsonify(map['selenium']);
    DRI thiamin = dejsonify(map['thiamin']);
    DRI vitaminE = dejsonify(map['vitaminE']);
    DRI vitaminA = dejsonify(map['vitaminA']);
    DRI vitaminB12 = dejsonify(map['vitaminB12']);
    DRI vitaminB6 = dejsonify(map['vitaminB6']);
    DRI vitaminC = dejsonify(map['vitaminC']);
    DRI vitaminD = dejsonify(map['vitaminD']);
    DRI vitaminK = dejsonify(map['vitaminK']);
    DRI zinc = dejsonify(map['zinc']);

    // No casting

    return DRIS(
        calcium: calcium,
        carbohydrate: carbohydrate,
        cholesterol: cholesterol,
        calories: calories,
        totalFat: totalFat,
        iron: iron,
        fiber: fiber,
        potassium: potassium,
        sodium: sodium,
        protein: protein,
        sugars: sugars,
        choline: choline,
        copper: copper,
        ala: ala,
        linoleicAcid: linoleicAcid,
        epa: epa,
        dpa: dpa,
        dha: dha,
        folate: folate,
        magnesium: magnesium,
        manganese: manganese,
        niacin: niacin,
        phosphorus: phosphorus,
        pantothenicAcid: pantothenicAcid,
        riboflavin: riboflavin,
        selenium: selenium,
        thiamin: thiamin,
        vitaminE: vitaminE,
        vitaminA: vitaminA,
        vitaminB12: vitaminB12,
        vitaminB6: vitaminB6,
        vitaminC: vitaminC,
        vitaminD: vitaminD,
        vitaminK: vitaminK,
        zinc: zinc);
  }
  // </Dataclass>

// </editor-fold>
}

@Dataclass(constructor: false)
class BaseNutrients {
  num grams;
  Nutrients nutrients;

  BaseNutrients({
    required this.grams,
    required this.nutrients,
  });

  // <editor-fold desc="Dataclass Section">
  @Generate()
  // <Dataclass>

  factory BaseNutrients.staticConstructor({
    required grams,
    required nutrients,
  }) =>
      BaseNutrients(grams: grams, nutrients: nutrients);

  Map<String, dynamic> get attributes__ =>
      {"grams": grams, "nutrients": nutrients};

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is BaseNutrients &&
          runtimeType == other.runtimeType &&
          equals(grams, other.grams) &&
          equals(nutrients, other.nutrients));

  @override
  int get hashCode => grams.hashCode ^ nutrients.hashCode;

  @override
  String toString() => 'BaseNutrients(grams: $grams, nutrients: $nutrients)';

  BaseNutrients copyWithBaseNutrients({num? grams, Nutrients? nutrients}) =>
      BaseNutrients(
          grams: grams ?? this.grams, nutrients: nutrients ?? this.nutrients);

  String toJson() => jsonEncode(toMap());
  Map<String, dynamic> toMap() =>
      {'__type': 'BaseNutrients', ...nestedJsonMap(attributes__)};

  factory BaseNutrients.fromJson(String json) =>
      BaseNutrients.fromMap(jsonDecode(json));

  factory BaseNutrients.fromMap(Map map) {
    num grams = map['grams'];
    Nutrients nutrients = dejsonify(map['nutrients']);

    // No casting

    return BaseNutrients(grams: grams, nutrients: nutrients);
  }
  // </Dataclass>

  // </editor-fold>
}

/// Settings Based Data Carriers

@Dataclass(constructor: false)
class AnthroMetrics {
  Sex sex;
  int age;
  int weight;
  int feet;
  int inches;
  Activity activity;

  int get cm => in2cm(inches + (feet * 12));
  set cm(int cm) {
    final temp = ImperialHeight.fromInches(cm2in(cm));
    feet = temp.feet;
    inches = temp.inches;
  }

  int get kg => lb2kg(weight);
  set kg(int kg) {
    weight = kg2lb(kg);
  }

  AnthroMetrics(
      {required this.sex,
      required this.age,
      required this.weight,
      required this.feet,
      required this.inches,
      required this.activity});

  // <editor-fold desc="Dataclass Section">
  @Generate()
  // <Dataclass>

  factory AnthroMetrics.staticConstructor({
    required sex,
    required age,
    required weight,
    required feet,
    required inches,
    required activity,
  }) =>
      AnthroMetrics(
          sex: sex,
          age: age,
          weight: weight,
          feet: feet,
          inches: inches,
          activity: activity);

  Map<String, dynamic> get attributes__ => {
        "sex": sex,
        "age": age,
        "weight": weight,
        "feet": feet,
        "inches": inches,
        "activity": activity
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is AnthroMetrics &&
          runtimeType == other.runtimeType &&
          equals(sex, other.sex) &&
          equals(age, other.age) &&
          equals(weight, other.weight) &&
          equals(feet, other.feet) &&
          equals(inches, other.inches) &&
          equals(activity, other.activity));

  @override
  int get hashCode =>
      sex.hashCode ^
      age.hashCode ^
      weight.hashCode ^
      feet.hashCode ^
      inches.hashCode ^
      activity.hashCode;

  @override
  String toString() =>
      'AnthroMetrics(sex: $sex, age: $age, weight: $weight, feet: $feet, inches: $inches, activity: $activity)';

  AnthroMetrics copyWithAnthroMetrics(
          {Sex? sex,
          int? age,
          int? weight,
          int? feet,
          int? inches,
          Activity? activity}) =>
      AnthroMetrics(
          sex: sex ?? this.sex,
          age: age ?? this.age,
          weight: weight ?? this.weight,
          feet: feet ?? this.feet,
          inches: inches ?? this.inches,
          activity: activity ?? this.activity);

  String toJson() => jsonEncode(toMap());
  Map<String, dynamic> toMap() =>
      {'__type': 'AnthroMetrics', ...nestedJsonMap(attributes__)};

  factory AnthroMetrics.fromJson(String json) =>
      AnthroMetrics.fromMap(jsonDecode(json));

  factory AnthroMetrics.fromMap(Map map) {
    Sex sex = dejsonify(map['sex']);
    int age = map['age'];
    int weight = map['weight'];
    int feet = map['feet'];
    int inches = map['inches'];
    Activity activity = dejsonify(map['activity']);

    // No casting

    return AnthroMetrics(
        sex: sex,
        age: age,
        weight: weight,
        feet: feet,
        inches: inches,
        activity: activity);
  }
  // </Dataclass>

  // </editor-fold>

  factory AnthroMetrics.fromMetric(
      Sex sex, int age, int weight, int height, Activity activity) {
    weight = kg2lb(weight);
    height = cm2in(height);
    int feet = height ~/ 12;
    int inches = height % 12;
    return AnthroMetrics(
        sex: sex,
        age: age,
        weight: weight,
        feet: feet,
        inches: inches,
        activity: activity);
  }

  Map<String, String> toDictForPost() {
    String sexStr = sex == Sex.M ? 'male' : 'female';
    Map<String, String> result = {
      'age_value': age.toString(),
      'sex': sexStr,
      'feet': feet.toString(),
      'inches': inches.toString(),
      'activity_level': activity.name.toString().replaceAll('_', ' '),
      'pounds': weight.toString()
    };
    if (sex == Sex.F) {
      result['pregnancy-lactating'] = 'none';
    }
    return result;
  }
}

@Dataclass()
class Settings {
  String apikey = '';
  String appId = '';
  bool darkMode = true;
  Measure measure;
  AnthroMetrics anthroMetrics;

  // <editor-fold desc="Dataclass Section">
  @Generate()
  // <Dataclass>

  Settings({
    required this.measure,
    required this.anthroMetrics,
    this.apikey = '',
    this.appId = '',
    this.darkMode = true,
  });

  factory Settings.staticConstructor({
    required measure,
    required anthroMetrics,
    apikey = '',
    appId = '',
    darkMode = true,
  }) =>
      Settings(
          measure: measure,
          anthroMetrics: anthroMetrics,
          apikey: apikey,
          appId: appId,
          darkMode: darkMode);

  Map<String, dynamic> get attributes__ => {
        "apikey": apikey,
        "appId": appId,
        "darkMode": darkMode,
        "measure": measure,
        "anthroMetrics": anthroMetrics
      };

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Settings &&
          runtimeType == other.runtimeType &&
          equals(apikey, other.apikey) &&
          equals(appId, other.appId) &&
          equals(darkMode, other.darkMode) &&
          equals(measure, other.measure) &&
          equals(anthroMetrics, other.anthroMetrics));

  @override
  int get hashCode =>
      apikey.hashCode ^
      appId.hashCode ^
      darkMode.hashCode ^
      measure.hashCode ^
      anthroMetrics.hashCode;

  @override
  String toString() =>
      'Settings(apikey: $apikey, appId: $appId, darkMode: $darkMode, measure: $measure, anthroMetrics: $anthroMetrics)';

  Settings copyWithSettings(
          {String? apikey,
          String? appId,
          bool? darkMode,
          Measure? measure,
          AnthroMetrics? anthroMetrics}) =>
      Settings(
          apikey: apikey ?? this.apikey,
          appId: appId ?? this.appId,
          darkMode: darkMode ?? this.darkMode,
          measure: measure ?? this.measure,
          anthroMetrics: anthroMetrics ?? this.anthroMetrics);

  String toJson() => jsonEncode(toMap());
  Map<String, dynamic> toMap() =>
      {'__type': 'Settings', ...nestedJsonMap(attributes__)};

  factory Settings.fromJson(String json) => Settings.fromMap(jsonDecode(json));

  factory Settings.fromMap(Map map) {
    String apikey = map['apikey'];
    String appId = map['appId'];
    bool darkMode = map['darkMode'];
    Measure measure = dejsonify(map['measure']);
    AnthroMetrics anthroMetrics = dejsonify(map['anthroMetrics']);

    // No casting

    return Settings(
        apikey: apikey,
        appId: appId,
        darkMode: darkMode,
        measure: measure,
        anthroMetrics: anthroMetrics);
  }
  // </Dataclass>

// </editor-fold>
}
