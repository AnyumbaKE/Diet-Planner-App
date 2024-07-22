/// Relevant Enums
enum Sex { M, F }

enum MCFTypes { meal, ingredient }

enum Activity {
  Sedentary,
  Low_Active,
  Active,
  Very_Active;

  static String toStr(Activity activity) {
    switch (activity) {
      case Activity.Sedentary:
        return 'Sedentary';
      case Activity.Low_Active:
        return 'Low Active';
      case Activity.Active:
        return 'Active';
      case Activity.Very_Active:
        return 'Very Active';
    }
  }
}

enum IngredientSource { string, upc, custom }

enum PopUpOptions { edit, delete, duplicate }

enum Measure { metric, imperial }
