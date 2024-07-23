/// Format to write in
///     'ingredient below': '''Write my note here multi-line is ok''',
/// Example:
///     'calcium': '''Overdosing on bone juice is bad''',
///     'protein': '''Omega gains''',
///     etc...
///
/// Valid Ingredient names for notes:
/// calcium
/// carbohydrate
/// cholesterol
/// calories
/// totalFat
/// iron
/// fiber
/// potassium
/// sodium
/// protein
/// sugars
/// choline
/// copper
/// ala
/// linoleicAcid
/// epa
/// dpa
/// dha
/// folate
/// magnesium
/// manganese
/// niacin
/// phosphorus
/// pantothenicAcid
/// riboflavin
/// selenium
/// thiamin
/// vitaminE
/// vitaminA
/// vitaminB12
/// vitaminB6
/// vitaminC
/// vitaminD
/// vitaminK
/// zinc
/// transFat
/// unsaturatedFat
/// saturatedFat

/// TODO: Add information about specific nutrients that may otherwise be missed,
/// like no UL for natty magnesium but supplements dangerous etc

final Map<String, String> driNotes = {
  'Calcium': '''
Write my note here
''',
// --------------------------------------
  'Carbohydrate': '''
Write my note here
''',
// --------------------------------------
  'Cholesterol': '''
Write my note here
''',
// --------------------------------------
  'Calories': '''
Write my note here
''',
// --------------------------------------
  'Total Fat': '''
Write my note here
''',
// --------------------------------------
  'Iron': '''
Iron note
''',
// --------------------------------------
  'Total Fiber': '''
Write my note here
''',
// --------------------------------------
  'Potassium': '''
Write my note here
''',
// --------------------------------------
  'Sodium': '''
Write my note here
''',
// --------------------------------------
  'Protein': '''
Write my note here
''',
// --------------------------------------
  'Sugars': '''
Write my note here
''',
// --------------------------------------
  'Choline': '''
Write my note here
''',
// --------------------------------------
  'Copper': '''
Write my note here
''',
// --------------------------------------
  'α-Linolenic Acid': '''
Write my note here
''',
// --------------------------------------
  'Linoleic Acid': '''
Write my note here
''',
// --------------------------------------
  'EPA': '''
Write my note here
''',
// --------------------------------------
  'DPA': '''
Write my note here
''',
// --------------------------------------
  'DHA': '''
Write my note here
''',
// --------------------------------------
  'Folate': '''
Write my note here
''',
// --------------------------------------
  'Magnesium': '''
Write my note here
''',
// --------------------------------------
  'Manganese': '''
Write my note here
''',
// --------------------------------------
  'Niacin': '''
Write my note here
''',
// --------------------------------------
  'Phosphorus': '''
Write my note here
''',
// --------------------------------------
  'Pantothenic Acid': '''
Write my note here
''',
// --------------------------------------
  'Riboflavin': '''
Write my note here
''',
// --------------------------------------
  'Selenium': '''
Write my note here
''',
// --------------------------------------
  'Thiamin': '''
Write my note here
''',
// --------------------------------------
  'Vitamin E': '''
Write my note here
''',
// --------------------------------------
  'Vitamin A': '''
Write my note here
''',
// --------------------------------------
  'Vitamin B12': '''
Write my note here
''',
// --------------------------------------
  'Vitamin B6': '''
Write my note here
''',
// --------------------------------------
  'Vitamin C': '''
Write my note here
''',
// --------------------------------------
  'Vitamin D': '''
Write my note here
''',
// --------------------------------------
  'Vitamin K': '''
Write my note here
''',
// --------------------------------------
  'Zinc': '''
Write my note here
''',
// --------------------------------------
  'Trans Fat': '''
Write my note here
''',
// --------------------------------------
  'Unsaturated Fat': '''
Write my note here
''',
// --------------------------------------
  'Saturated Fat': '''
Write my note here
''',
// --------------------------------------
}.map((key, value) => MapEntry(key, value.trim()));
